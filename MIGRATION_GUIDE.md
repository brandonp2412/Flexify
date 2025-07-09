# Migration Guide: From deploy.sh to GitHub Actions

This guide helps you transition from using the `deploy.sh` script to the new GitHub Actions workflow for automated deployments.

## Quick Start

1. **Configure Secrets**: Add required secrets to your GitHub repository settings (see [Required Secrets](#required-secrets) below)
2. **Test the Workflow**: Run the workflow with all store deployments skipped initially
3. **Gradually Enable Stores**: Enable each store deployment one by one after testing
4. **Archive Old Scripts**: Move or delete the old deployment scripts once confident in the new workflow

## Required Secrets Configuration

Go to your GitHub repository → Settings → Secrets and variables → Actions, then add:

### Essential Secrets

```
GOOGLE_PLAY_JSON_KEY=<your-google-play-service-account-json>
MSSTORE_APP_ID=9P13THVK7F69
APPLE_ID=<your-apple-id-email>
APPLE_APP_SPECIFIC_PASSWORD=<your-app-specific-password>
INSTALLER_CERT_NAME=<your-mac-installer-certificate-name>
```

### Optional Secrets (for code signing)

```
ANDROID_KEYSTORE_BASE64=<base64-encoded-keystore-file>
ANDROID_KEYSTORE_PASSWORD=<keystore-password>
ANDROID_KEY_ALIAS=<key-alias>
ANDROID_KEY_PASSWORD=<key-password>
```

## Command Line Equivalents

### Old deploy.sh Usage → New GitHub Actions

| Old Command | New Action |
|-------------|------------|
| `./deploy.sh` | Run "Deploy Release" workflow with all options enabled |
| `./deploy.sh -w` | Run workflow with "Skip Windows Store deployment" checked |
| `./deploy.sh -p` | Run workflow with "Skip Google Play deployment" checked |
| `./deploy.sh -m` | Run workflow with "Skip macOS deployment" checked |
| `./deploy.sh -w -p -m` | Run workflow with all store deployments skipped |

### Testing Equivalent

| Old Command | New Action |
|-------------|------------|
| `./scripts/tag-release.sh -t` | Run workflow with "Skip tests and screenshots" checked |

## Feature Comparison

| Feature | deploy.sh | GitHub Actions | Notes |
|---------|-----------|----------------|-------|
| Version bumping | ✅ | ✅ | Same logic, automated |
| Changelog generation | ✅ (manual edit) | ✅ (auto-generated) | Can still edit files manually before workflow |
| Android builds | ✅ | ✅ | APK + AAB, split per ABI |
| Linux builds | ✅ | ✅ | Native GitHub runner |
| Windows builds | ✅ (Docker) | ✅ | Native GitHub runner |
| macOS builds | ✅ (SSH) | ✅ | Native GitHub runner |
| iOS builds | ✅ (SSH) | ✅ | Native GitHub runner |
| GitHub releases | ✅ | ✅ | Automated with artifacts |
| Google Play deploy | ✅ | ✅ | Via fastlane |
| Windows Store deploy | ✅ | ⚠️ | Needs msstore CLI setup |
| Mac App Store deploy | ✅ | ✅ | Via fastlane |
| Parallel builds | ❌ | ✅ | Much faster |
| Build isolation | ❌ | ✅ | Better reliability |

## Migration Steps

### Step 1: Backup Current Setup

```bash
# Create backup of current scripts
mkdir -p backup/scripts
cp -r scripts/ backup/
cp deploy.sh backup/
```

### Step 2: Test GitHub Actions

1. Push the new workflow files to your repository
2. Go to Actions tab and run "Deploy Release" workflow
3. Check all "Skip" options for initial test
4. Verify the workflow completes successfully

### Step 3: Configure Store Deployments

#### Google Play Store

1. Create a service account in Google Cloud Console
2. Download the JSON key file
3. Base64 encode it: `base64 -w 0 service-account.json`
4. Add as `GOOGLE_PLAY_JSON_KEY` secret

#### Windows Store

1. Install Microsoft Store CLI tool locally
2. Test authentication with your credentials
3. Add `MSSTORE_APP_ID` secret (value: `9P13THVK7F69`)

#### Apple App Store

1. Generate app-specific password in Apple ID settings
2. Add `APPLE_ID` and `APPLE_APP_SPECIFIC_PASSWORD` secrets
3. Add certificate name as `INSTALLER_CERT_NAME` secret

### Step 4: Gradual Rollout

1. **Week 1**: Run with all stores skipped, verify builds work
2. **Week 2**: Enable Google Play deployment only
3. **Week 3**: Enable Windows Store deployment
4. **Week 4**: Enable Apple App Store deployment
5. **Week 5**: Full deployment with all stores

### Step 5: Clean Up

Once confident in the new workflow:

```bash
# Archive old scripts
mkdir -p archive
mv deploy.sh archive/
mv scripts/tag-release.sh archive/
mv scripts/github.sh archive/
mv scripts/copy-changelogs.sh archive/
```

## Troubleshooting Migration Issues

### Common Problems

1. **"Uncommitted changes" error**
   - Solution: Commit all changes before running workflow
   - Old script checked this too, but workflow is stricter

2. **Missing secrets errors**
   - Solution: Verify all secrets are configured correctly
   - Check secret names match exactly (case-sensitive)

3. **Build failures**
   - Solution: Check individual job logs for specific errors
   - May need to update dependencies or Flutter version

4. **Store deployment failures**
   - Solution: Test store credentials locally first
   - Verify API access and permissions

### Rollback Plan

If you need to rollback to the old system:

1. Restore scripts from backup:
   ```bash
   cp backup/deploy.sh .
   cp -r backup/scripts/ .
   ```

2. Disable the GitHub Actions workflow:
   - Go to Actions tab
   - Select the workflow
   - Click "..." → "Disable workflow"

3. Continue using `./deploy.sh` as before

## Benefits of Migration

### Immediate Benefits

- **Parallel Builds**: All platforms build simultaneously
- **No Local Dependencies**: No need for Docker, SSH, or local macOS machine
- **Better Logging**: Detailed logs for each step
- **Artifact Management**: All builds stored and downloadable
- **Rollback Capability**: Easy to rerun specific jobs

### Long-term Benefits

- **Scalability**: Easy to add new platforms or deployment targets
- **Maintenance**: No need to maintain local build infrastructure
- **Security**: Secrets managed by GitHub, not local files
- **Collaboration**: Team members can trigger deployments without local setup
- **Reliability**: GitHub's infrastructure is more reliable than local machines

## Getting Help

If you encounter issues during migration:

1. Check the [workflow README](.github/workflows/README.md) for detailed documentation
2. Review GitHub Actions logs for specific error messages
3. Test individual components (builds, deployments) separately
4. Consider running with store deployments disabled initially

## Post-Migration Checklist

- [ ] All required secrets configured
- [ ] Workflow runs successfully with stores skipped
- [ ] Google Play deployment works
- [ ] Windows Store deployment works
- [ ] Apple App Store deployment works
- [ ] GitHub releases created correctly
- [ ] All artifacts uploaded properly
- [ ] Team members can access and run workflow
- [ ] Old scripts archived or removed
- [ ] Documentation updated
