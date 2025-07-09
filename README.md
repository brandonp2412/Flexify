# Flexify

Flex on people with this swanky, lightning-quick gym tracker!

<p float="left">
    <a href="https://github.com/brandonp2412/Flexify/releases/latest"><img alt="GitHub Release" src="https://img.shields.io/github/v/release/brandonp2412/flexify?style=for-the-badge&logoColor=d3bcfd&labelColor=d3bcfd&color=151218"></a>
    <a href="#"><img alt="Release downloads" src="https://img.shields.io/github/downloads/brandonp2412/Flexify/total.svg?style=for-the-badge&logoColor=d3bcfd&labelColor=d3bcfd&color=151218"></a>
</p>

## Features

- 💪 **Strength**: Log your reps and weights with ease.
- 📵 **Offline**: Flexify doesn't use the internet at all.
- 📈 **Graphs**: Visualize your progress over time with intuitive graphs.
- 🏃 **Cardio**: Record your progress with cardio types.
- ⚙️ **Custom**: Toggle features on/off, swap between light/dark theme and much more.
- ⏱️ **Timers**: Stay focused with alarms after resting.

<a href='https://play.google.com/store/apps/details?id=com.presley.flexify'><img alt='Get it on Google Play' height="75" src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>
<a href="https://f-droid.org/packages/com.presley.flexify"><img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="75"></a>

<a href="https://apps.microsoft.com/detail/Flexify/9P13THVK7F69?mode=direct"><img src="https://get.microsoft.com/images/en-us%20dark.svg" height="75"/></a>
<a href="https://apps.apple.com/us/app/flexify/id6503730178?itsct=apps_box_badge&amp;itscg=30200"><img src="docs/download-apple.svg" alt="Download on the App Store" height="75"></a>

## Screenshots

<p float="left">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/1_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/2_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/3_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/4_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/5_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/6_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/7_en-US.png" height="600">
    <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/8_en-US.png" height="600">
</p>

## Donations

Contributing to Flexify is directly correlated with Gains
- Bitcoin `bc1qzlte8featxzf7xvtp3rjv7qqtwkgpup8hu85gp`
- Monero (XMR) `85tmLfWKbpd8nxQnUY878DDuFjmfcoCFXPWR7XYKLHBSbDZV8wxgoKYUtHtq1kHWJg4m14sdBXhYuUSbxEDA29d19XuREL5`
- [GitHub sponsor](https://github.com/sponsors/brandonp2412)

## Getting Started

To get started with Flexify, follow these steps:

1. **Clone the Repository**: Clone the Flexify repository to your local machine using Git:

   ```bash
   git clone --recursive https://github.com/brandonp2412/Flexify flexify
   ```

2. **Install Dependencies**: Navigate to the project directory and install the necessary dependencies:

   ```bash
   cd flexify
   flutter pub get
   ```

3. **Run the App**: Launch the Flexify app on your preferred device or emulator:

   ```bash
   flutter run
   ```

## ChromeDriver Setup

For automated screenshot testing, you'll need to download ChromeDriver:

### Windows

1. **Download ChromeDriver**: Download the latest ChromeDriver for Windows:
   ```bash
   curl -L -o chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/win64/chromedriver-win64.zip"
   ```

2. **Extract**: Extract the downloaded zip file:
   ```bash
   tar -xf chromedriver.zip
   ```

### macOS/Linux

1. **Download ChromeDriver**: Download the appropriate version for your system:
   ```bash
   # For macOS (Intel)
   curl -L -o chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/mac-x64/chromedriver-mac-x64.zip"
   
   # For macOS (Apple Silicon)
   curl -L -o chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/mac-arm64/chromedriver-mac-arm64.zip"
   
   # For Linux
   curl -L -o chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chromedriver-linux64.zip"
   ```

2. **Extract**: Extract the downloaded zip file:
   ```bash
   unzip chromedriver.zip
   ```

**Note**: ChromeDriver files are excluded from git due to their size. You'll need to download them locally for screenshot testing to work.

## Migrations

If you edit any of the models in the `lib/database` directory you probably need to create migrations. E.g. assume the version starts at `1`.

1. Bump the `schemaVersion`
   `lib/database/database.dart`

```dart
  int get schemaVersion => 2;
```

2. Run database migrations

```sh
./scripts/migrate.sh
```

3. Add the migration step
   `lib/database/database.dart`

```dart
from1To2: (Migrator m, Schema2 schema) async {
  await m.addColumn(schema.myTable, schema.myTable.myColumn);
},
```

## Contributing

All issues and pull requests are welcome. We don't care what style it's in, we don't care what your variable names are.

## License

Flexify is licensed under the [MIT License](LICENSE.md).
