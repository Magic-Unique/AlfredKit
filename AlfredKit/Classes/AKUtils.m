//
//  AKUtils.m
//  AlfredKit
//
//  Created by 吴双 on 2019/2/16.
//

#import "AKUtils.h"

NSString *AKModKeyGetName(AKModKey key) {
    switch (key) {
        case AKModKeyCommand:
            return @"cmd";
        case AKModKeyOption:
            return @"alt";
        case AKModKeyControl:
            return @"ctrl";
        case AKModKeyShift:
            return @"shift";
        case AKModKeyFn:
            return @"fn";
        default:
            break;
    }
    return nil;
}

NSString *AKBOOLGetName(BOOL value) {
    return value ? @"true" : @"false";
}

@implementation NSXMLElement (AlfredKit)

- (void)ak_addChild:(NSXMLElement *)child {
    if (child) {
        [self addChild:child];
    }
}

+ (id)ak_elementWithName:(NSString *)name stringValue:(NSString *)string {
    if (string) {
        return [self elementWithName:name stringValue:string];
    } else {
        return nil;
    }
}

@end

