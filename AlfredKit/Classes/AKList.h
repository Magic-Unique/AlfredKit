//
//  AKList.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKList : NSObject <AKContent>

/**
 Use XML Mode,
 
 XML mode is deprecated by Alfred. but the XML format will remain available for legacy use.
 */
@property (nonatomic, assign) BOOL useXMLMode;

@property (nonatomic, copy, readonly) NSArray<AKItem *> *items;

/**
 Create a list with XML mode.
 
 XML mode is deprecated by Alfred. but the XML format will remain available for legacy use.
 @return AKList in XML Mode.
 */
+ (instancetype)XMLList;

/**
 Create a list with JSON mode.

 @return AKList in JSON Mode.
 */
+ (instancetype)JSONList;

- (void)addItem:(AKItem *)item;
- (void)addItemWithCreator:(AKItemCreator)creator;
- (void)addItems:(NSArray *)items;

/**
 Format to string and output to Alfred console.
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
