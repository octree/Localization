# Localization
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)

**Localization** is a framework for in-app language changes, providing reactive API so that the app can be translated in real time.

## Example

Basic
```swift
label.l10n.text.bind(.pure("Hello"))
languageButton.l10n.title(for: .normal).bind(key: "Language")
```
Operations
```swift
let localizer = Localizer.pure("Part 1")
    .combine(.pure("Part 2"))
    .map { $0 + " " + $1 }
    .map { NSAttributedString(string: $0, attributes: [.foregroundColor: UIColor.systemPink]) }
label.l10n.attributedText.bind(localizer)
```

## Requirements

* iOS 13.0+
* Swift 5.0+

## Installation

### Swift Package Manager
* File > Swift Packages > Add Package Dependency
* Add https://github.com/octree/Localization.git
* Select "Up to Next Major" with "1.0.0"

## Author

Octree, fouljz@gmail.com

## License

**Localization** is available under the MIT license. See the LICENSE file for more info.
