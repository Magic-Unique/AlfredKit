//
//  AKItem.h
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import "AKContent.h"
#import "AKItemModifier.h"
#import "AKItemText.h"
#import "AKItemIcon.h"
#import "AKItemSubtitle.h"

/*
 JSON help: https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
 XML help:  https://www.alfredapp.com/help/workflows/inputs/script-filter/xml/
 */

@class AKItem;

typedef void(^AKItemCreator)(AKItem *_Nonnull item);

typedef NS_ENUM(NSUInteger, AKItemType) {
    AKItemTypeDefault,
    AKItemTypeFile,
    AKItemTypeFile_SkipCheck,
};
FOUNDATION_EXTERN NSString * _Nullable AKItemTypeGetName(AKItemType type);

@interface AKItem : NSObject <AKContent>

/**
 This is a unique identifier for the item which allows help Alfred to learn about this item for subsequent sorting and ordering of the user's actioned results.
 
 It is important that you use the same UID throughout subsequent executions of your script to take advantage of Alfred's knowledge and sorting. If you would like Alfred to always show the results in the order you return them from your script, exclude the UID field.
 */
@property (nonatomic, copy, nullable) NSString *uid;

/**
 The title displayed in the result row. There are no options for this element and it is essential that this element is populated.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 The subtitle displayed in the result row. This element is optional.
 */
@property (nonatomic, copy, nullable) NSString *subtitle;

/**
 Show subtitles when hold on modifier key. Only enable for XML mode.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<AKItemSubtitle *> *subtitles;
- (AKItemSubtitle * _Nonnull)setSubtitle:(NSString * _Nonnull)subtitle mod:(AKModKey)mod;

/**
 The argument which is passed through the workflow to the connected output action.
 
 While the arg attribute is optional, it's highly recommended that you populate this as it's the string which is passed to your connected output actions. If excluded, you won't know which result item the user has selected.
 */
@property (nonatomic, copy, nullable) NSString *arg;

/**
 By specifying type="file", this makes Alfred treat your result as a file on your system. This allows the user to perform actions on the file like they can with Alfred's standard file filters.
 
 When returning files, Alfred will check if the file exists before presenting that result to the user. This has a very small performance implication but makes the results as predictable as possible. If you would like Alfred to skip this check as you are certain that the files you are returning exist, you can use type="file:skipcheck".
 */
@property (nonatomic, assign) AKItemType type;

/**
 The icon displayed in the result row. Workflows are run from their workflow folder, so you can reference icons stored in your workflow relatively.
 
 By omitting the "type", Alfred will load the file path itself, for example a png. By using "type": "fileicon", Alfred will get the icon for the specified path. Finally, by using "type": "filetype", you can get the icon of a specific file, for example "path": "public.png"
 */
@property (nonatomic, copy, readonly, nonnull) AKItemIcon *icon;

/**
 If this item is valid or not. If an item is valid then Alfred will action this item when the user presses return. If the item is not valid, Alfred will do nothing. This allows you to intelligently prevent Alfred from actioning a result based on the current {query} passed into your script.
 
 If you exclude the valid attribute, Alfred assumes that your item is valid.
 */
@property (nonatomic, assign) BOOL valid;

/**
 From Alfred 3.5, the match field enables you to define what Alfred matches against when the workflow is set to "Alfred Filters Results". If match is present, it fully replaces matching on the title property.
 
 Note that the match field is always treated as case insensitive, and intelligently treated as diacritic insensitive. If the search query contains a diacritic, the match becomes diacritic sensitive.
 */
@property (nonatomic, copy, nullable) NSString *match;

/**
 An optional but recommended string you can provide which is populated into Alfred's search field if the user auto-complete's the selected result (⇥ by default).
 
 If the item is set as "valid": false, the auto-complete text is populated into Alfred's search field when the user actions the result.
 */
@property (nonatomic, copy, nullable) NSString *autocomplete;

/**
 The mod element gives you control over how the modifier keys react. You can now define the valid attribute to mark if the result is valid based on the modifier selection and set a different arg to be passed out if actioned with the modifier.
 
 From Alfred 3.4.1, you can define an icon and variables for each object in the mods object.
 */
@property (nonatomic, strong, readonly, nonnull) NSArray<AKItemModifier *> *mods;
- (AKItemModifier * _Nonnull)setMod:(AKModKey)mod subtitle:(NSString * _Nonnull)subtitle arg:(NSString * _Nullable)arg;

/**
 The text element defines the text the user will get when copying the selected result row with ⌘C or displaying large type with ⌘L.
 
 If these are not defined, you will inherit Alfred's standard behaviour where the arg is copied to the Clipboard or used for Large Type.
 */
@property (nonatomic, strong, readonly, nonnull) AKItemText *onCopyText;
- (void)setCopyText:(NSString * _Nullable)text;
@property (nonatomic, strong, readonly, nonnull) AKItemText *onLargeText;
- (void)setLargeText:(NSString * _Nullable)text;

/**
 A Quick Look URL which will be visible if the user uses the Quick Look feature within Alfred (tapping shift, or cmd+y). Note that quicklookurl will also accept a file path, both absolute and relative to home using ~/.
 */
@property (nonatomic, copy, nullable) NSString *quicklookurl;

+ (instancetype _Nonnull)item;
+ (instancetype _Nonnull)itemWithCreator:(AKItemCreator _Nonnull)creator;

@end
