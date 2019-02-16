//
//  AKUtils.h
//  AlfredKit
//
//  Created by 吴双 on 2019/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AKModKey) {
    AKModKeyCommand,
    AKModKeyOption,
    AKModKeyControl,
    AKModKeyShift,
    AKModKeyFn,
};

FOUNDATION_EXTERN NSString *AKModKeyGetName(AKModKey key);

FOUNDATION_EXTERN NSString *AKBOOLGetName(BOOL value);

@interface NSXMLElement (AlfredKit)

- (void)ak_addChild:(NSXMLElement *)child;

+ (id)ak_elementWithName:(NSString *)name stringValue:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
