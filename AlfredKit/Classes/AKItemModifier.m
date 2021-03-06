//
//  AKMod.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKItemModifier.h"

@implementation AKItemModifier

- (instancetype)init {
    self = [super init];
    if (self) {
        _valid = YES;
    }
    return self;
}

- (id)JSON {
    if (!self.subtitle && !self.arg) {
        return nil;
    }
    NSMutableDictionary *JSON = [NSMutableDictionary dictionary];
    JSON[@"subtitle"] = self.subtitle;
    JSON[@"valid"] = @(self.valid);
    JSON[@"arg"] = self.arg;
    return JSON;
}

- (NSXMLElement *)XMLElement {
    if (!self.subtitle && !self.arg) {
        return nil;
    }
    NSXMLElement *mod = [NSXMLElement elementWithName:@"mod"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[@"key"] = AKModKeyGetName(self.key);
    attributes[@"subtitle"] = self.subtitle;
    attributes[@"valid"] = AKBOOLGetName(self.valid);
    attributes[@"arg"] = self.arg;
    [mod setAttributesWithDictionary:attributes];
    return mod;
}

@end
