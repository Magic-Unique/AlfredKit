//
//  AKMod.h
//  AlfredKit
//
//  Created by 吴双 on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"
#import "AKUtils.h"

@interface AKModifier : NSObject <AKContent>

@property (nonatomic, assign) AKModKey key;

@property (nonatomic, assign) BOOL valid;

@property (nonatomic, copy) NSString *arg;

@property (nonatomic, copy) NSString *subtitle;

@end
