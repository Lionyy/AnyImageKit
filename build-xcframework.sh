#!/bin/bash

projectName="AnyImageKit"
version="0.10.0"

deleteLastSameBuild() {
    rm -r "Products/${version}"
    rm -r "Build/${version}"
}

buildFramework() {
    
    # Device slice.
    xcodebuild archive \
    -project "${projectName}.xcodeproj" \
    -scheme "${projectName}" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "Build/${version}/${projectName}.framework-iphoneos.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    # Simulator slice.
    xcodebuild archive \
    -project "$projectName.xcodeproj" \
    -scheme "$projectName" \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "Build/$version/$projectName.framework-iphonesimulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    # Mac Catalyst slice.
    # xcodebuild archive \
    # -workspace "$projectName.xcworkspace" \
    # -scheme "$projectName" \
    # -configuration Release \
    # -destination "platform=macOS,arch=x86_64,variant=Mac Catalyst" \
    # -archivePath "Build/$version/$projectName.framework-catalyst.xcarchive" \
    # SKIP_INSTALL=NO \
    # BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    # Export
    # xcodebuild -create-xcframework \
    # -framework "Build/$version/$projectName.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/$projectName.framework" \
    # -framework "Build/$version/$projectName.framework-iphoneos.xcarchive/Products/Library/Frameworks/$projectName.framework" \
    # -framework "Build/$version/$projectName.framework-catalyst.xcarchive/Products/Library/Frameworks/$projectName.framework" \
    # -output "Products/$version/$projectName.xcframework"

    xcodebuild -create-xcframework \
    -framework "Build/$version/$projectName.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/$projectName.framework" \
    -framework "Build/$version/$projectName.framework-iphoneos.xcarchive/Products/Library/Frameworks/$projectName.framework" \
    -output "Products/$version/$projectName.xcframework"
}

zipFramework() {
    cp -r "Products/$version" "Products/$projectName-$version"
    cd "Products"
    zip -r "$projectName-$version.zip" "$projectName-$version"
    rm -r "$projectName-$version"
}

# Main

deleteLastSameBuild
buildFramework
# zipFramework
