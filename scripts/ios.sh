#!/bin/sh

set -ex

flutter build ipa
fastlane deliver --ipa build/ios/ipa/flexify.ipa
