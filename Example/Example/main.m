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
        AKList *list = [[AKList alloc] init];
        [list addItem:[AKItem itemWithCreator:^(AKItem *item) {
            item.title = @"title";
            item.subtitle = @"subtitle";
        }]];
        [list show];
    }
    return 0;
}
