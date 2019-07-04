//
//  main.m
//  Example
//
//  Created by Magic-Unique on 2019/2/5.
//  Copyright © 2019 Magic-Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlfredKit/AlfredKit.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AKScriptFilter *list = [[AKScriptFilter alloc] init];
        list.useXMLMode = NO;
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
        [list addItemWithCreator:^(AKItem *item) {
            item.title = @"Desktop";
            item.subtitle = NSDate.date.description; // test for `rerun`
            item.arg = @"Desktop";
            item.type = AKItemTypeFile;
            [item.icon setFileIconWithPath:@"~/Desktop"];
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
            item.quicklookurl = @"~/Desktop";
        }];
        list.variables[@"a"] = @"b";
        list.rerun = 1;
        [list print];
    }
    return 0;
}
