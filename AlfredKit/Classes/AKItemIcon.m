//
//  AKItemIcon.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKItemIcon.h"
#import "AKUtils.h"

@implementation AKItemIcon

- (void)setFileIconWithPath:(NSString *)path {
    _content = path;
    _type = AKItemIconTypeFileIcon;
}

- (void)setFileTypeWithPathExtension:(NSString *)pathExtension {
    _content = pathExtension;
    _type = AKItemIconTypeFileType;
}

- (void)setImageWithPath:(NSString *)path {
    _content = path;
    _type = AKItemIconTypeNone;
}

- (void)remove {
    _type = AKItemIconTypeNone;
    _content = nil;
}

- (id)JSON {
    NSString *type = [AKItemIcon typeName:self.type];
    NSString *path = self.content;
    if (path) {
        NSMutableDictionary *JSON = [NSMutableDictionary dictionary];
        JSON[@"type"] = type;
        JSON[@"path"] = path;
        return JSON;
    } else {
        return nil;
    }
}

- (NSXMLElement *)XMLElement {
    if (!self.content) {
        return nil;
    }
    NSXMLElement *icon = [NSXMLElement ak_elementWithName:@"icon" stringValue:self.content];
    if (self.type) {
        NSString *type = [AKItemIcon typeName:self.type];
        [icon setAttributesWithDictionary:NSDictionaryOfVariableBindings(type)];
    }
    return icon;
}

+ (NSString *)typeName:(AKItemIconType)type {
    if (type == AKItemIconTypeFileType) {
        return @"filetype";
    } else if (type == AKItemIconTypeFileIcon) {
        return @"fileicon";
    } else {
        return nil;
    }
}

@end
