//
//  AKSubtitle.m
//  AlfredKit
//
//  Created by 吴双 on 2019/2/16.
//

#import "AKSubtitle.h"
#import "AKUtils.h"

@implementation AKSubtitle

/* Subtitle only for XML mode */
- (id)JSON {
    return nil;
}

- (NSXMLElement *)XMLElement {
    NSString *mod = AKModKeyGetName(self.mod);
    if (mod && self.subtitle) {
        NSXMLElement *element = [NSXMLElement ak_elementWithName:@"subtitle" stringValue:self.subtitle];
        [element setAttributesWithDictionary:@{@"mod":mod}];
        return element;
    } else {
        return nil;
    }
}

@end
