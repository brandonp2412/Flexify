"""Browser regression for the persisted sql.js to Drift WASM migration.

Build with `flutter build web --release -t tool/web_migration_e2e.dart`,
then run using a Python environment with Playwright installed.
"""

import asyncio
import hashlib
import os
import shutil
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from threading import Thread

from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parents[1]
WEB_ROOT = ROOT / 'build/web'
FIXTURE = ROOT / 'test/fixtures/legacy_web.sqlite'

SEED = """async (kind) => {
  const response = await fetch('legacy_fixture.sqlite');
  if (!response.ok) throw Error('fixture not found');
  const buffer = await response.arrayBuffer();
  if (kind === 'localstorage') {
    const latin1 = Array.from(new Uint8Array(buffer), byte => String.fromCharCode(byte)).join('');
    localStorage.setItem('moor_db_str_flexify_db', latin1);
  } else {
    const request = indexedDB.open('moor_databases', 1);
    const db = await new Promise((resolve, reject) => {
      request.onupgradeneeded = () => request.result.createObjectStore('moor_databases');
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
    const transaction = db.transaction('moor_databases', 'readwrite');
    transaction.objectStore('moor_databases').put(new Blob([buffer]), 'flexify_db');
    await new Promise((resolve, reject) => {
      transaction.oncomplete = resolve;
      transaction.onerror = () => reject(transaction.error);
    });
    db.close();
  }
  return buffer.byteLength;
}"""

LEGACY_STILL_EXISTS = """async (kind) => {
  let bytes;
  if (kind === 'localstorage') {
    const latin1 = localStorage.getItem('moor_db_str_flexify_db');
    if (!latin1) throw Error('Original localStorage data missing');
    bytes = Uint8Array.from(latin1, character => character.charCodeAt(0));
  } else {
    const request = indexedDB.open('moor_databases', 1);
    const db = await new Promise((resolve, reject) => {
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
    const transaction = db.transaction('moor_databases', 'readonly');
    const get = transaction.objectStore('moor_databases').get('flexify_db');
    const blob = await new Promise((resolve, reject) => {
      get.onsuccess = () => resolve(get.result);
      get.onerror = () => reject(get.error);
    });
    db.close();
    if (!blob) throw Error('Original IndexedDB data missing');
    bytes = new Uint8Array(await blob.arrayBuffer());
  }
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest), b => b.toString(16).padStart(2, '0')).join('');
}"""


class StaticFiles(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_ROOT), **kwargs)

    def log_message(self, fmt, *args):
        pass


async def verify_kind(browser, origin, kind):
    context = await browser.new_context()
    try:
        page = await context.new_page()
        errors = []
        page.on('pageerror', lambda error: errors.append(str(error)))
        await page.goto(origin + '/seed.html')
        size = await page.evaluate(SEED, kind)
        assert size == FIXTURE.stat().st_size

        await page.goto(origin + '/?phase=initial')
        await page.get_by_text('MIGRATION_OK:initial').wait_for(timeout=30000)
        await page.goto(origin + '/?phase=verify')
        await page.get_by_text('MIGRATION_OK:verify').wait_for(timeout=30000)

        retained_hash = await page.evaluate(LEGACY_STILL_EXISTS, kind)
        original_hash = hashlib.sha256(FIXTURE.read_bytes()).hexdigest()
        assert retained_hash == original_hash, (kind, retained_hash, original_hash)
        assert not errors, errors
        print(f'{kind}: imported records, persisted writes, original SHA-256 unchanged')
    finally:
        await context.close()


async def main():
    assert (WEB_ROOT / 'main.dart.js').is_file(), 'Build the browser test entrypoint first'
    assert (WEB_ROOT / 'sqlite3.wasm').is_file(), 'Missing sqlite3.wasm'
    assert (WEB_ROOT / 'drift_worker.dart.js').is_file(), 'Missing Drift worker'
    shutil.copyfile(FIXTURE, WEB_ROOT / 'legacy_fixture.sqlite')
    (WEB_ROOT / 'seed.html').write_text('<!doctype html><title>Legacy Drift fixture</title>')
    server = ThreadingHTTPServer(('127.0.0.1', 0), StaticFiles)
    server_thread = Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    origin = f'http://127.0.0.1:{server.server_port}'
    try:
        async with async_playwright() as playwright:
            browser = await playwright.chromium.launch(
                executable_path=os.environ.get('BRAVE_PATH', '/usr/bin/brave'),
                headless=True,
                args=['--no-sandbox'],
            )
            try:
                for kind in ('indexeddb', 'localstorage'):
                    await verify_kind(browser, origin, kind)
            finally:
                await browser.close()
    finally:
        server.shutdown()
        (WEB_ROOT / 'legacy_fixture.sqlite').unlink(missing_ok=True)
        (WEB_ROOT / 'seed.html').unlink(missing_ok=True)


if __name__ == '__main__':
    asyncio.run(main())
