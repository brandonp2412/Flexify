# Fastforge packaging migration: Flexify

## Production behaviour

The `Build and Release` workflow now uses **pinned Fastforge 0.6.12** to package
Android's universal release APK and AAB, Linux ZIP, and Windows ZIP. It keeps
all of its release cadence logic, quality checks, screenshot generation,
GitHub Releases, GitHub Pages, Microsoft Store publishing, and VirusTotal jobs.
Normal pushes do not publish anything. The original downstream artifact names
and `actions/download-artifact` / GitHub Release paths are preserved.

The F-Droid-critical three split-per-ABI APKs are still built by the exact
Flutter commands used in the published F-Droid recipe, with `--split-per-abi`
and `--target-platform android-x64`, `android-arm`, and `android-arm64`.
Fastforge does **not** substitute for those F-Droid builds. The script
`scripts/verify-fastforge-android-parity.sh` checks that the Fastforge APK is
byte-for-byte the same as the same-revision direct Flutter universal APK,
then builds the three F-Droid variants, verifies package ID and version codes
(`build_number * 100 + 1/2/3`), and verifies every APK has the canonical
release signing certificate. Build products are staged under the original
`android-builds`, `linux-builds`, and `windows-builds` artifact names.

The Flutter SDK is taken **only** from the repository's pinned `flutter`
submodule. CI repairs shallow tag ancestry before dependency resolution
without changing the checked-out Flutter commit. Android builds use a bind
mount to run at `/home/brandon/flexify` with `ANDROID_HOME=/opt/android-sdk`
and a project-local `PUB_CACHE`. This retains GitHub's original checkout so
JavaScript actions can upload artifacts and run post-job cleanup.

## Verified evidence

Baseline source SHA: `4cd8480f0fb1e471a9dcf6d151e709f2e9801792`.
Pinned Flutter SHA: `6a19cca56475dbfba1478ee68d7bd0c2ef891da1`
(Flutter 3.47.5). Fastforge CLI: `0.6.12`.

- `flutter analyze` passed and `flutter test` passed **2,606 tests** on Nox.
- `actionlint` checked the GitHub workflows; new verification shell script
  passed `shellcheck` and `bash -n`.
- [Hosted Linux](https://github.com/brandonp2412/Flexify/actions/runs/38095301278)
  built/uploaded a ZIP with 589 entries.
- [Hosted Windows](https://github.com/brandonp2412/Flexify/actions/runs/38095303621)
  built/uploaded a ZIP with 600 entries, including `flexify.exe`.
- Compared with the existing published Flexify 2.2.33 ZIPs, **no existing
  archive paths are missing**. The differences are six newer changelog
  translation assets and, on Windows, directory entries.
- [Hosted Android initial build](https://github.com/brandonp2412/Flexify/actions/runs/38097995625)
  successfully built/uploaded the signed universal APK and AAB.
- [Hosted full Android parity check](https://github.com/brandonp2412/Flexify/actions/runs/38100756357)
  **passed** all checks and artifact upload: Fastforge's universal APK was
  byte-for-byte equal to the direct Flutter universal APK from the same source,
  all three F-Droid ABI APKs were built and had the expected package ID,
  architecture-specific version codes, and canonical certificate.
- The signing certificate SHA-256 was
  `011ee1a6e4e5ecd675f67fbf3d78ad82614a7a7a3f24ed71cc9c417154a0f0fd`,
  matching F-Droid's published `AllowedAPKSigningKeys` for Flexify.
- No test was deleted or loosened. All eight non-packaging GitHub release jobs
  were compared structurally and remained unchanged.

### Evidence limitations

The hosted parity check proves identical same-run **universal** signed APKs,
ABI-specific package structure, version codes, and signing identity. An
independent F-Droid rebuild of a future newly released revision is needed to
prove bit-for-bit reproducibility against the F-Droid build servers. The
archived pilot runs did not publish to any store; the production publish
jobs were not executed as part of this migration.

## Actual size and trade-off

The original five GitHub workflows contained **989 lines**, with **663** in
`.github/workflows/main.yml`. After promotion and deletion of the temporary
pilot workflow there are **972 GitHub YAML lines**, of which **646** are in
`main.yml` (only **17 lines saved**, or 1.7%). Fastforge adds 24 lines of
`distribute_options.yaml` and the required 39-line Android verification
script: **1,035 total automation-code/config lines** compared with 989 before
the pilot. This is a **4.7% increase**, not the previously forecast 30%+
reduction. The benefit is upstream-managed cross-platform ZIP/APK/AAB
packaging and a single reproducibility guard, not reduced line count.

The manual `fastforge-pilot.yml` was used to certify the transition and is
removed after promotion. Its completed proof runs remain available via the
GitHub Actions links above. The next scheduled production release still needs
monitoring; nothing in this report claims a production store publication
happened during the migration.
