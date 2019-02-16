//
//  AKSubtitle.h
//  AlfredKit
//
//  Created by 吴双 on 2019/2/16.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"
#import "AKUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKSubtitle : NSObject <AKContent>

@property (nonatomic, assign) AKModKey mod;

@property (nonatomic, copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
