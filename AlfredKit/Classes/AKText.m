//
//  AKText.m
//  AlfredKit
//
//  Created by 吴双 on 2019/2/15.
//

#import "AKText.h"
#import "AKUtils.h"

@implementation AKText

+ (instancetype)textWithType:(AKTextType)type {
    AKText *item = [[AKText alloc] init];
    item->_type = type;
    return item;
}

- (id)JSON {
    return self.text;
}

- (NSXMLElement *)XMLElement {
    NSString *type = [AKText typeName:self.type];
    if (!self.text || !type) {
        return nil;
    }
    NSXMLElement *text = [NSXMLElement ak_elementWithName:@"text" stringValue:self.text];
    [text setAttributesWithDictionary:@{@"type":type}];
    return text;
}

+ (NSString *)typeName:(AKTextType)type {
    switch (type) {
        case AKTextTypCopy:
            return @"copy";
        case AKTextTypeLargeType:
            return @"largetype";
        default:
            break;
    }
    return nil;
}

@end
