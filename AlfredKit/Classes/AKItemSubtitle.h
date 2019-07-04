//
//  AKItemSubtitle.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/16.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"
#import "AKUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKItemSubtitle : NSObject <AKContent>

@property (nonatomic, assign) AKModKey mod;

@property (nonatomic, copy, nullable) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
