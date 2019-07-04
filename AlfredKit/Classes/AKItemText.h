//
//  AKItemText.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"


typedef NS_ENUM(NSUInteger, AKItemTextType) {
    AKItemTextTypCopy,
    AKItemTextTypeLargeType,
};

@interface AKItemText : NSObject <AKContent>

@property (nonatomic, assign, readonly) AKItemTextType type;

@property (nonatomic, copy, nullable) NSString *text;

+ (instancetype _Nonnull)textWithType:(AKItemTextType)type;

@end
