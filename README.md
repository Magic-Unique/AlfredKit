# AlfredKit

[![CI Status](https://img.shields.io/travis/Magic-Unique/AlfredKit.svg?style=flat)](https://travis-ci.org/Magic-Unique/AlfredKit)
[![Version](https://img.shields.io/cocoapods/v/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)
[![License](https://img.shields.io/cocoapods/l/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)
[![Platform](https://img.shields.io/cocoapods/p/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objc
AKList *list = [[AKList alloc] init];
list.useXMLMode = NO;
/*
 * Use XML mode, default is NO. 
 * XML mode is deprecated by Alfred.
 * If `useXMLMode` is NO, it will use JSON mode. 
 */

//	Add an item to list
[list addItemWithCreator:^(AKItem *item) {
    item.title = @"title";
    item.subtitle = @"subtitle";
    item.autocomplete = @"aktool";
    item.arg = @"arg";
    [item.icon setFileTypeWithPathExtension:@"app"];
    [item setSubtitle:@"subtitle AKModKeyCommand" mod:AKModKeyCommand];
    [item setSubtitle:@"subtitle AKModKeyOption" mod:AKModKeyOption];
    [item setSubtitle:@"subtitle AKModKeyControl" mod:AKModKeyControl];
    [item setSubtitle:@"subtitle AKModKeyShift" mod:AKModKeyShift];
    [item setSubtitle:@"subtitle AKModKeyFn" mod:AKModKeyFn];
    [item setMod:AKModKeyCommand subtitle:@"mod AKModKeyCommand" arg:@"AKModKeyCommand"];
    [item setMod:AKModKeyOption subtitle:@"mod AKModKeyOption" arg:@"AKModKeyOption"];
    [item setMod:AKModKeyControl subtitle:@"mod AKModKeyControl" arg:nil];
    [item setMod:AKModKeyShift subtitle:@"mod AKModKeyShift" arg:@"AKModKeyShift"];
    [item setMod:AKModKeyFn subtitle:@"mod AKModKeyFn" arg:@"AKModKeyFn"];
    [item setCopyText:@"onCopyText"];
    [item setLargeText:@"onLargeText"];
    item.quicklookurl = @"https://www.baidu.com";
}];

//	Format string and output to Alfred console.
[list show];
```

## Installation

AlfredKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlfredKit'
```

## Author

Magic-Unique, 516563564@qq.com

## License

AlfredKit is available under the MIT license. See the LICENSE file for more info.
