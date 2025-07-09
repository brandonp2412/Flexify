# GitHub Workflows

This directory contains GitHub Actions workflows for building and deploying the Flexify app across multiple platforms.

## Workflows

### Individual Platform Workflows

- **`macos.yml`** - Builds macOS application
- **`windows.yml`** - Builds Windows application

### Main Deployment Workflow

- **`deploy.yml`** - Complete deployment pipeline that builds for all platforms and creates releases

## Testing with `act`

The workflows have been configured to work with [`act`](https://github.com/nektos/act) for local testing.

### Prerequisites

1. Install Docker
2. Install `act`: `winget install nektos.act` (Windows) or follow [installation guide](https://github.com/nektos/act#installation)
3. Configure `.actrc` file (already present in project root)

### Running Tests

```bash
# Test macOS workflow
act -W .github/workflows/macos.yml --container-architecture linux/amd64

# Test Windows workflow  
act -W .github/workflows/windows.yml --container-architecture linux/amd64

# Test specific job from deploy workflow
act -W .github/workflows/deploy.yml --job build-linux --container-architecture linux/amd64

# Dry run (faster, shows workflow structure)
act -W .github/workflows/macos.yml --container-architecture linux/amd64 --dryrun
```

## Platform-Specific Build Handling

The individual platform workflows (`macos.yml` and `windows.yml`) include OS detection logic:

- **On actual GitHub runners**: Builds work normally on their respective platforms
- **With `act` testing**: Automatically detects non-native environment and skips platform-specific builds with informative messages

This allows for:
- ✅ Successful local testing with `act` 
- ✅ Proper builds when running on GitHub Actions
- ✅ Clear feedback about what's happening in each environment

## Key Features

### Updated Dependencies
- Uses `actions/checkout@v4` (latest)
- Uses `subosito/flutter-action@v2` (with caching support)
- Enables platform-specific Flutter desktop support automatically

### Caching
- Flutter SDK caching for faster builds
- Pub dependencies caching
- Reduces build times significantly

### Error Handling
- Graceful handling of platform mismatches during local testing
- Clear error messages and skip logic
- Maintains workflow success even when builds are skipped

## Troubleshooting

### Common Issues

1. **"Could not find a subcommand named 'macos'"**
   - This is expected when testing macOS workflow on non-macOS systems
   - The workflow will automatically skip the build and show a message

2. **"build windows only supported on Windows hosts"**
   - This is expected when testing Windows workflow on non-Windows systems  
   - The workflow will automatically skip the build and show a message

3. **Deploy workflow fails with "uncommitted changes"**
   - The deploy workflow has safety checks to prevent releases with uncommitted changes
   - Commit your changes before testing the deploy workflow

### Configuration

The `.actrc` file maps GitHub runner types to Docker images:
```
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P ubuntu-22.04=catthehacker/ubuntu:act-22.04
-P ubuntu-20.04=catthehacker/ubuntu:act-20.04
-P windows-latest=catthehacker/ubuntu:act-latest
-P macos-latest=catthehacker/ubuntu:act-latest
```

This configuration allows `act` to simulate different runner types using Ubuntu containers.
