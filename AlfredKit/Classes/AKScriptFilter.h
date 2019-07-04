//
//  AKScriptFilter.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKItem.h"

typedef NS_ENUM(NSUInteger, AKScriptFilterStyle) {
    AKScriptFilterStyleJSON,
    AKScriptFilterStyleXML,
};

@interface AKScriptFilter : NSObject <AKContent>

/**
 Use XML Mode,
 
 XML mode is deprecated by Alfred. but the XML format will remain available for legacy use.
 */
@property (nonatomic, assign) BOOL useXMLMode;

/**
 Create a list with XML mode.
 
 XML mode is deprecated by Alfred. but the XML format will remain available for legacy use.
 @return AKScriptFilter in XML Mode.
 */
+ (instancetype _Nonnull)XMLScriptFilter;

/**
 Create a list with JSON mode.

 @return AKScriptFilter in JSON Mode.
 */
+ (instancetype _Nonnull)JSONScriptFilter;

/**
 Items
 */
@property (nonatomic, copy, readonly, nonnull) NSMutableArray<AKItem *> *items;
- (void)addItem:(AKItem * _Nonnull)item;
- (void)addItemWithCreator:(AKItemCreator _Nonnull)creator;
- (void)addItems:(NSArray * _Nonnull)items;

/**
 Variables in result list.
 
 Variables can be passed out of the script filter within a variables object. This is useful for two things. Firstly, these variables will be passed out of the script filter's outputs when actioning a result. Secondly, any variables passed out of a script will be passed back in as environment variables when the script is run within the same session. This can be used for very simply managing state between runs as the user types input or when the script is set to re-run after an interval.
 */
@property (nonatomic, strong, readonly, nonnull) NSMutableDictionary *variables;


/**
 Rerun time interval.
 
 Scripts can be set to re-run automatically after an interval using the 'rerun' key with a value of 0.1 to 5.0 seconds. The script will only be re-run if the script filter is still active and the user hasn't changed the state of the filter by typing and triggering a re-run.
 */
@property (nonatomic, assign) NSTimeInterval rerun;

/**
 Format to string and output to Alfred console.
 */
- (void)show __deprecated_msg("-[AKScriptFilter show] is deprecated, use `print` or `prettyPrint` instead.");

/**
 Format to string and output to Alfred console.
 */
- (void)print;

/**
 Format to string with pretty style and output to Alfred console.
 */
- (void)prettyPrint;

@end
