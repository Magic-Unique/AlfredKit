//
//  AKText.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"


typedef NS_ENUM(NSUInteger, AKTextType) {
    AKTextTypCopy,
    AKTextTypeLargeType,
};

@interface AKText : NSObject <AKContent>

@property (nonatomic, assign, readonly) AKTextType type;

@property (nonatomic, copy) NSString *text;

+ (instancetype)textWithType:(AKTextType)type;

@end
