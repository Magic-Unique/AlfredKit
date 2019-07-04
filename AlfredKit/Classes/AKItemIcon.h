//
//  AKItemIcon.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AKItemIconType) {
    AKItemIconTypeNone,
    AKItemIconTypeFileIcon,
    AKItemIconTypeFileType,
};

@interface AKItemIcon : NSObject <AKContent>

@property (nonatomic, assign, readonly) AKItemIconType type;

@property (nonatomic, copy, readonly, nullable) NSString *content;

- (void)setFileIconWithPath:(NSString * _Nonnull)path;

- (void)setFileTypeWithPathExtension:(NSString * _Nonnull)pathExtension;

- (void)setImageWithPath:(NSString * _Nonnull)path;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
