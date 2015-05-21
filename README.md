# YMBarbwire

[![CI Status](http://img.shields.io/travis/adamkaplan/YMBarbwire.svg?style=flat)](https://travis-ci.org/adamkaplan/YMBarbwire)
[![Version](https://img.shields.io/cocoapods/v/YMBarbwire.svg?style=flat)](http://cocoadocs.org/docsets/YMBarbwire)
[![License](https://img.shields.io/cocoapods/l/YMBarbwire.svg?style=flat)](http://cocoadocs.org/docsets/YMBarbwire)
[![Platform](https://img.shields.io/cocoapods/p/YMBarbwire.svg?style=flat)](http://cocoadocs.org/docsets/YMBarbwire)

## Usage

```
#import <YMBarbwire/YMBarbwire.h>
#import <YMBarbwire/UIView+YMBarbwire.h>

+ (void)load {
  [UIView wireAll]; // wire all supported methods of UIView
}

- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opts {
  dispatch_queue_t queue = dispatch_queue_create("nuke", DISPATCH_QUEUE_CONCURRENT);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), queue, ^{
    // This will assert immediately; Barbwire detects the call into UIView from background thread.
    [self.window setNeedsLayout];
  });
}

// Supported methods of UIView, currently
// - Methods that do not begin with _
// - Methods that do not return structures or functions
```

## Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YMBarbwire is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "YMBarbwire"

## Author

adamkaplan, adamkaplan@yahoo-inc.com

## License

YMBarbwire is available under the MIT license. See the LICENSE file for more info.

