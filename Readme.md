![Restofire-Gloss: A component library for Restofire to serialize responses into Gloss](https://raw.githubusercontent.com/Restofire/Restofire/master/.github/restofire.png)

## Restofire-Gloss

[![Platforms](https://img.shields.io/cocoapods/p/Restofire.svg)](https://cocoapods.org/pods/Restofire-Gloss)
[![License](https://img.shields.io/cocoapods/l/Restofire.svg)](https://raw.githubusercontent.com/Restofire/Restofire-Gloss/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Restofire-Gloss.svg)](https://cocoapods.org/pods/Restofire-Gloss)

[![Travis](https://img.shields.io/travis/Restofire/Restofire-Gloss/master.svg)](https://travis-ci.org/Restofire/Restofire-Gloss/branches)

[![Join the chat at https://gitter.im/Restofire/Restofire](https://badges.gitter.im/Restofire/Restofire.svg)](https://gitter.im/Restofire/Restofire?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Restofire-Gloss is a component library for [Restofire](http://github.com/Restofire/Restofire) to serialize responses into Gloss

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Restofire-Gloss 1.0.0+.

To integrate Restofire-Gloss into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Restofire-Gloss', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Restofire-Gloss into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "RahulKatariya/Restofire-Gloss" ~> 1.0
```
### Swift Package Manager

To use Restofire as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloRestofireGloss",
    dependencies: [
        .Package(url: "https://github.com/Restofire/Restofire-Gloss.git", majorVersion: 1)
    ]
)
```

## Usage

### Configuring Restofire

```swift
import Restofire

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Restofire.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
        Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
        Restofire.defaultConfiguration.logging = true
        Restofire.defaultConfiguration.authentication.credential = NSURLCredential(user: "user", password: "password", persistence: .ForSession)
        Restofire.defaultConfiguration.validation.acceptableStatusCodes = [200..<300]
        Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
        Restofire.defaultConfiguration.retry.retryErrorCodes = [NSURLErrorTimedOut,NSURLErrorNetworkConnectionLost]
        Restofire.defaultConfiguration.retry.retryInterval = 20
        Restofire.defaultConfiguration.retry.maxRetryAttempts = 10
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.timeoutIntervalForRequest = 7
        sessionConfiguration.timeoutIntervalForResource = 7
        sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        Restofire.defaultConfiguration.manager = Alamofire.Manager(configuration: sessionConfiguration)

        return true
  }

}
```

### Creating a Gloss Model

```swift
import Gloss

struct Person: Decodable {

    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let name: String = "name" <~~ json else { return nil }

        self.id = id
        self.name = name
    }

}

extension Person: Equatable { }

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
```

### Creating a Service

```swift
import Restofire

class PersonGETService: Requestable {

    typealias Model = Person
    var path: String = "56c2cc70120000c12673f1b5"

}

```

### Consuming the Service

```swift
import Restofire

class ViewController: UIViewController {

    var person: Person!
    var requestOp: RequestOperation!

    func getPerson() {
        requestOp = PersonGETService().executeTask() {
            if let value = $0.result.value {
                person = value
            }
        }
    }

    deinit {
        requestOp.cancel()
    }

}
```

## License

Restofire is released under the MIT license. See [LICENSE](https://github.com/Restofire/Restofire-Gloss/blob/master/LICENSE) for details.
