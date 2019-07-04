//
//  AKItemText.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKItemText.h"
#import "AKUtils.h"

@implementation AKItemText

+ (instancetype)textWithType:(AKItemTextType)type {
    AKItemText *item = [[AKItemText alloc] init];
    item->_type = type;
    return item;
}

- (id)JSON {
    return self.text;
}

- (NSXMLElement *)XMLElement {
    NSString *type = [AKItemText typeName:self.type];
    if (!self.text || !type) {
        return nil;
    }
    NSXMLElement *text = [NSXMLElement ak_elementWithName:@"text" stringValue:self.text];
    [text setAttributesWithDictionary:@{@"type":type}];
    return text;
}

+ (NSString *)typeName:(AKItemTextType)type {
    switch (type) {
        case AKItemTextTypCopy:
            return @"copy";
        case AKItemTextTypeLargeType:
            return @"largetype";
        default:
            break;
    }
    return nil;
}

@end
