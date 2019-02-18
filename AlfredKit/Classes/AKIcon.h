//
//  AKIcon.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AKIconType) {
    AKIconTypeNone,
    AKIconTypeFileIcon,
    AKIconTypeFileType,
};

@interface AKIcon : NSObject <AKContent>

@property (nonatomic, assign, readonly) AKIconType type;

@property (nonatomic, copy, readonly) NSString *content;

- (void)setFileIconWithPath:(NSString *)path;

- (void)setFileTypeWithPathExtension:(NSString *)pathExtension;

- (void)setImageWithPath:(NSString *)path;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
