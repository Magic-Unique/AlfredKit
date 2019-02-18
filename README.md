# AlfredKit

[![CI Status](https://img.shields.io/travis/Magic-Unique/AlfredKit.svg?style=flat)](https://travis-ci.org/Magic-Unique/AlfredKit)
[![Version](https://img.shields.io/cocoapods/v/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)
[![License](https://img.shields.io/cocoapods/l/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)
[![Platform](https://img.shields.io/cocoapods/p/AlfredKit.svg?style=flat)](https://cocoapods.org/pods/AlfredKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objc
AKScriptFilter *scriptFilter = [[AKScriptFilter alloc] init];
scriptFilter.useXMLMode = NO;
/*
 * Use XML mode, default is NO. 
 * XML mode is deprecated by Alfred.
 * If `useXMLMode` is NO, it will use JSON mode. 
 */

//	Add an item to list
[scriptFilter addItemWithCreator:^(AKItem *item) {
	// title
	item.title = @"title";
	item.subtitle = @"subtitle";
	
	//	auto complete with TAB key
	item.autocomplete = @"aktool";
	
	//	arg for next step
	item.arg = @"arg";
	
	//	icon, [FileType|FileIcon|Image]
	[item.icon setFileTypeWithPathExtension:@"app"];
	
	//	subtitle (only for XML mode)
	//	When user hold on the mod key, Alfred will display the first arg as subtitle
	[item setSubtitle:@"subtitle AKModKeyCommand" mod:AKModKeyCommand];
	[item setSubtitle:@"subtitle AKModKeyOption" mod:AKModKeyOption];
	[item setSubtitle:@"subtitle AKModKeyControl" mod:AKModKeyControl];
	[item setSubtitle:@"subtitle AKModKeyShift" mod:AKModKeyShift];
	[item setSubtitle:@"subtitle AKModKeyFn" mod:AKModKeyFn];
	
	//	Mod key (recommand, for XML and JSON)
	//	When user hold on the mod key, Alfred will display the subtitle.
	//	If user hold on the mod key and press RETURN, the arg will pass to next step.
	[item setMod:AKModKeyCommand subtitle:@"mod AKModKeyCommand" arg:@"AKModKeyCommand"];
	[item setMod:AKModKeyOption subtitle:@"mod AKModKeyOption" arg:@"AKModKeyOption"];
	[item setMod:AKModKeyControl subtitle:@"mod AKModKeyControl" arg:nil];
	[item setMod:AKModKeyShift subtitle:@"mod AKModKeyShift" arg:@"AKModKeyShift"];
	[item setMod:AKModKeyFn subtitle:@"mod AKModKeyFn" arg:@"AKModKeyFn"];
	
	//	When user press cmd+C, the text will be copied.
	[item setCopyText:@"onCopyText"];
	
	//	When user press cmd+L, the text will display on LargeType window.
	[item setLargeText:@"onLargeText"];
	
	//	When user press cmd+Y or Shift, the url or path will open in QuickLook window.
	item.quicklookurl = @"https://www.alfredapp.com";
}];

//  Add variables to list, on next step, you can use {var:name} query to get them.
scriptFilter.varables[@"name"] = @"value";

//	Set rerun time interval.
scriptFilter.rerun = 1;

//	Format string and output to Alfred console.
[scriptFilter show];
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
