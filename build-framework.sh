#!/bin/bash


projectName="AnyImageKit"

deleteCarthage() {
    rm -r Carthage
}

build() {
    set -euo pipefail

    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
    trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

    # For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
    # the build will fail on lipo due to duplicate architectures.
    echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_12B45b = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
    echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
    echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig
    echo 'ONLY_ACTIVE_ARCH=NO' >> $xcconfig
    echo 'VALID_ARCHS = $(inherited) x86_64' >> $xcconfig
    export XCODE_XCCONFIG_FILE="$xcconfig"
    echo $XCODE_XCCONFIG_FILE

    carthage build --no-skip-current --configuration "Release" --platform iOS 
}

copyFramework() {
    cp -Rf "Carthage/Build/iOS/Static/$projectName.framework" ../AnyImageKit/
}

# # Main
deleteCarthage
build
copyFramework
