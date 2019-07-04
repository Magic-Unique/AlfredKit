//
//  AKMod.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"
#import "AKUtils.h"

@interface AKItemModifier : NSObject <AKContent>

@property (nonatomic, assign) AKModKey key;

@property (nonatomic, assign) BOOL valid;

@property (nonatomic, copy, nullable) NSString *arg;

@property (nonatomic, copy, nullable) NSString *subtitle;

@end
