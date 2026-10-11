# Fastforge build-only pilot

This is an opt-in packaging experiment. The existing `Build and Release` workflow, its
quality checks, its fortnightly release gate, Google Play, Microsoft Store, VirusTotal,
and F-Droid procedures remain authoritative and unchanged.

## Running on GitHub

After this workflow reaches the default branch, open **Actions → Fastforge packaging
pilot → Run workflow** and choose `android`, `linux`, or `windows`. Each run builds
artifacts for inspection with a three-day retention period. There are **no**
publication credentials or `publish` / GitHub Release commands in the pilot.

Fastforge is pinned at `0.6.12`. All Flutter and Dart commands use the `flutter`
submodule gitlink recorded in the repository, including the Fastforge installation.
`FLUTTER_ROOT` and `PATH` point to that checkout. The Android job additionally
reproduces the production/F-Droid path `/home/brandon/flexify` as a bind
mount of `$GITHUB_WORKSPACE` (rather than moving the checkout), normalized Android
SDK root `/opt/android-sdk`, project-local `PUB_CACHE`, Java 21 and existing Gradle
runner-memory settings. The Android artifacts must pass the project's canonical
certificate verification. Signing secrets are only supplied to the Android job;
the pilot has read-only GitHub permissions and never pushes tags or releases.

On Nox, in a separate worktree, use the same Flutter submodule commit and run:

```sh
export FLUTTER_ROOT="$PWD/flutter"
export PUB_CACHE="$PWD/.pub-cache"
export PATH="$FLUTTER_ROOT/bin:$PUB_CACHE/bin:$PATH"
flutter/bin/flutter pub get --enforce-lockfile
flutter/bin/dart pub global activate fastforge 0.6.12
flutter/bin/dart run build_runner build -d
fastforge --no-version-check release --name pilot-linux
```

If initializing the submodule with a shallow clone, `flutter --version` may show
`0.0.0-unknown` because Git tag ancestry is missing. Deepen the *submodule's
history* without changing the pinned checkout (`git -C flutter fetch --deepen=200
origin`). Do not use a different system Flutter to work around this.
The GitHub-hosted Linux pilot initially reproduced this problem; all three
runner setups now fetch missing ancestry before resolving dependencies.
The first hosted Android run successfully built and verified its APK/AAB but
failed at artifact upload: moving `$GITHUB_WORKSPACE` broke JavaScript actions'
post-step working directory. The bind mount retains the original checkout for
all actions while preserving the required build path.

## Baseline and measured evidence

- Existing five workflow files: approximately 992 lines in the baseline checkout.
- The main release workflow: approximately 663 lines at the baseline SHA
  `4cd8480f0fb1e471a9dcf6d151e709f2e9801792`.
- Pinned SDK commit: `6a19cca56475dbfba1478ee68d7bd0c2ef891da1`
  (reported as Flutter 3.47.5 when local tag ancestry was restored).
- Fastforge 0.6.12 was installed and its `pilot-linux` job successfully produced
  `dist/fastforge-pilot/2.2.33+447/flexify-2.2.33+447-linux.zip` on Nox.
  The ZIP included 589 entries; its `flexify` executable had the same SHA-256
  as `build/linux/x64/release/bundle/flexify`:
  `9a00ab81ba6b4e83eb6bc425d1651725e5fd572a14bed5737e6bd42d24e05f86`.
- `actionlint` 1.7.12 validated the new GitHub workflow.
- `flutter analyze` passed; `flutter test` passed 2,606 tests on Nox.
- Hosted GitHub Actions succeeded for Linux
  ([run 38095301278](https://github.com/brandonp2412/Flexify/actions/runs/38095301278)),
  Windows ([run 38095303621](https://github.com/brandonp2412/Flexify/actions/runs/38095303621))
  and Android ([run 38097995625](https://github.com/brandonp2412/Flexify/actions/runs/38097995625)).
  All three uploaded build artifacts successfully without invoking publication.
- The downloaded Windows ZIP had 600 entries including `flexify.exe`.
  The Linux ZIP had 589 entries including `flexify`.
- The uploaded Android APK was 74,023,466 bytes and its SHA-256 was
  `847f0b0becc05b6a539fc2b0f7beb1efd568e77f1644a9cc84b983a909d20f72`.
  It contains native libraries for arm64-v8a, armeabi-v7a and x86_64.
  The uploaded AAB was 71,147,609 bytes with SHA-256
  `f7254c7c08736a39143a28e5cfa4a66892016bb54308ba7cea49540c510c19c6`.
  The hosted Android job verified the canonical signer of the APK.
- The experiment is an additive validation stage, **not a LOC reduction**:
  the baseline contained 992 workflow lines; the enabled pilot adds a 178-line
  workflow plus 24 lines of Fastforge configuration. Migration should only
  replace production jobs after the parity checks below pass.
- This verifies that Fastforge packaged the locally built Linux executable
  unaltered; it **does not** establish equivalence with a historical production
  release or with the complete F-Droid reproducible APK.

## Promotion gate

Before replacing any existing release job:

1. ~~Complete Android and Windows GitHub runs and inspect their produced artifacts.~~ Done.
2. Compare the Android APK/AAB manifests, hashes where reproducibility applies,
   ABI coverage, package ID, version, certificate and F-Droid build requirements
   with the current release path. The existing pipeline also emits three
   split-per-ABI APKs; the first Fastforge pilot deliberately only tests a
   universal APK and AAB, so it is **not yet a complete substitute**.
3. Compare Linux and Windows ZIP layouts and key files against production
   outputs for the same source revision, not merely successful compilation.
4. Confirm no store publication or mutable Git operations occur during packaging.
5. Keep existing checks and publishing workflows until all comparisons pass.
   Evaluate total automation-config LOC as well as YAML LOC; target at least 30%
   genuine reduction before adoption.
