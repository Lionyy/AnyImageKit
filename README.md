![AnyImageKit](https://github.com/AnyImageProject/AnyImageProject.github.io/raw/master/Resources/TitleMap@2x.png)

[![GitHub Actions](https://github.com/AnyImageProject/AnyImageKit/workflows/build/badge.svg?branch=master)](https://github.com/AnyImageProject/AnyImageKit/actions?query=workflow%3Abuild)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AnyImageKit.svg)](https://cocoapods.org/pods/AnyImageKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/AnyImageKit.svg?style=flat)](./)
[![License](https://img.shields.io/cocoapods/l/AnyImageKit.svg?style=flat)](https://raw.githubusercontent.com/AnyImageProject/AnyImageKit/master/LICENSE)

`AnyImageKit` is a toolbox for picking, editing or capturing photos/videos, written in Swift. 

> [中文说明](./Documentation/README_CN.md)

## Features

- [x] Light mode, dark mode or auto mode support
- [x] Default theme is similar with Wechat 
- [x] Multiple & mix select support
- [x] Supported media types:
    - [x] Photo
    - [x] GIF
    - [x] Live Photo
    - [x] Video
- [x] Camera
    - [x] Photo
    - [x] Video
    - [ ] Live Photo
    - [ ] GIF
    - [ ] Fliter Support
- [ ] Edit image ( Technical Preview )
    - [x] Drawing
    - [ ] Emoji
    - [x] Input text
    - [x] Cropping
    - [x] Mosaic
    - [ ] Rotate
    - [ ] Fliter Support
- [ ] Multiple platform support
    - [x] iOS
    - [x] iPadOS
    - [ ] Mac Catalyst ( Technical Preview, Not support in editor. Remove from support as Xcode 12.0 can't support Mac Catalyst 14.0 features. )
    - [ ] macOS
    - [ ] tvOS

## Requirements

- iOS 10.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

⚠️ Needs Xcode 12.0+ to support resources and localization files

```swift
dependencies: [
    .package(url: "https://github.com/AnyImageProject/AnyImageKit.git", .upToNextMajor(from: "0.9.0"))
]
```

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Add this to `Podfile`, and then update dependency:

```ruby
pod 'AnyImageKit'
```

### ~~[Carthage](https://github.com/Carthage/Carthage)~~

~~Add this to `Cartfile`, and then update dependency:~~

```ogdl
github "AnyImageProject/AnyImageKit"
```

⚠️ Unsupport in Xcode 12.0, [more details](https://github.com/Carthage/Carthage/issues/3019)

## Usage

### Prepare

Add these keys to your Info.plist when needed:

| Key | Module | Info |
| ----- | ----  | ---- |
| NSPhotoLibraryUsageDescription | Picker |  |
| NSPhotoLibraryAddUsageDescription | Picker |  |
| PHPhotoLibraryPreventAutomaticLimitedAccessAlert | Picker | Set `YES` to prevent automatic limited access alert in iOS 14+ (Picker has been adapted with Limited features that can be triggered by the user to enhance the user experience) |
| NSCameraUsageDescription | Capture |  |
| NSMicrophoneUsageDescription | Capture |  |

### Quick Start

```swift
import AnyImageKit

class ViewController: UIViewController {

    @IBAction private func openPicker(_ sender: UIButton) {
        var options = PickerOptionsInfo()
        /*
          Your code, handle custom options
        */
        let controller = ImagePickerController(options: options, delegate: self)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: ImagePickerControllerDelegate {

    func imagePickerDidCancel(_ picker: ImagePickerController) {
        /*
          Your code, handle user cancel
        */
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        let images = result.assets.map { $0.image }
        /*
          Your code, handle selected assets
        */
        picker.dismiss(animated: true, completion: nil)
    }
}
```

## Release Notes

* [v0.10.0](https://github.com/AnyImageProject/AnyImageKit/blob/master/Documentation/RELEASE_NOTE.md#0100): Release on 2020-11-03

* [v0.9.0](https://github.com/AnyImageProject/AnyImageKit/blob/master/Documentation/RELEASE_NOTE.md#090): Release on 2020-10-09

## License

AnyImageKit is released under the MIT license. See [LICENSE](./LICENSE) for details.
