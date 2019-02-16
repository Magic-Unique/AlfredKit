//
//  AKIcon.m
//  AlfredKit
//
//  Created by 吴双 on 2019/2/15.
//

#import "AKIcon.h"
#import "AKUtils.h"

@implementation AKIcon

- (void)setFileIconWithPath:(NSString *)path {
    _content = path;
    _type = AKIconTypeFileIcon;
}

- (void)setFileTypeWithPathExtension:(NSString *)pathExtension {
    _content = pathExtension;
    _type = AKIconTypeFileType;
}

- (void)setImageWithPath:(NSString *)path {
    _content = path;
    _type = AKIconTypeNone;
}

- (void)remove {
    _type = AKIconTypeNone;
    _content = nil;
}

- (id)JSON {
    NSString *type = [AKIcon typeName:self.type];
    NSString *path = self.content;
    if (type && path) {
        return NSDictionaryOfVariableBindings(type, path);
    }
    return path;
}

- (NSXMLElement *)XMLElement {
    if (!self.content) {
        return nil;
    }
    NSXMLElement *icon = [NSXMLElement ak_elementWithName:@"icon" stringValue:self.content];
    if (self.type) {
        NSString *type = [AKIcon typeName:self.type];
        [icon setAttributesWithDictionary:NSDictionaryOfVariableBindings(type)];
    }
    return icon;
}

+ (NSString *)typeName:(AKIconType)type {
    if (type == AKIconTypeFileType) {
        return @"filetype";
    } else if (type == AKIconTypeFileIcon) {
        return @"fileicon";
    } else {
        return nil;
    }
}

@end