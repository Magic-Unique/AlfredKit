//
//  AKItem.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKItem.h"

NSString *AKItemTypeGetName(AKItemType type) {
    switch (type) {
        case AKItemTypeDefault:
            return @"default";
        case AKItemTypeFile:
            return @"file";
        case AKItemTypeFile_SkipCheck:
            return @"file:skipcheck";
        default:
            break;
    }
    return nil;
}

@interface AKItem ()

@property (nonatomic, strong, readonly) NSMutableArray *mSubtitles;

@property (nonatomic, strong, readonly) NSMutableDictionary *mMods;

@end

@implementation AKItem

+ (instancetype)item {
    return [[self alloc] init];
}

+ (instancetype)itemWithCreator:(AKItemCreator)creator {
    AKItem *item = [[AKItem alloc] init];
    !creator?:creator(item);
    return item;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _valid = YES;
    }
    return self;
}

- (AKItemModifier *)setMod:(AKModKey)key subtitle:(NSString *)subtitle arg:(NSString *)arg {
    AKItemModifier *mod = [[AKItemModifier alloc] init];
    mod.key = key;
    mod.subtitle = subtitle;
    mod.arg = arg;
    self.mMods[AKModKeyGetName(mod.key)] = mod;
    return mod;
}

- (NSArray<AKItemModifier *> *)mods {
    return self.mMods.allValues;
}

- (AKItemSubtitle *)setSubtitle:(NSString *)subtitle mod:(AKModKey)mod {
    AKItemSubtitle *item = [[AKItemSubtitle alloc] init];
    item.subtitle = subtitle;
    item.mod = mod;
    [self.mSubtitles addObject:item];
    return item;
}

- (NSArray<AKItemSubtitle *> *)subtitles {
    return [self.mSubtitles copy];
}

- (void)setCopyText:(NSString *)text {
    self.onCopyText.text = text;
}

- (void)setLargeText:(NSString *)text {
    self.onLargeText.text = text;
}

#pragma mark - AKContent

- (id)JSON {
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    item[@"uid"] = self.uid;
    item[@"title"] = self.title;
    item[@"subtitle"] = self.subtitle;
    item[@"arg"] = self.arg;
    item[@"icon"] = self.icon.JSON;
    item[@"valid"] = @(self.valid);
    item[@"match"] = self.match;
    item[@"autocomplete"] = self.autocomplete;
    item[@"type"] = AKItemTypeGetName(self.type);
    if (self.mMods.count) {
        NSMutableDictionary *mods = [NSMutableDictionary dictionary];
        for (AKItemModifier *mod in self.mMods.allValues) {
            mods[AKModKeyGetName(mod.key)] = mod.JSON;
        }
        item[@"mods"] = mods;
    }
    if (self.onCopyText.text || self.onLargeText.text) {
        NSMutableDictionary *text = [NSMutableDictionary dictionary];
        text[@"copy"] = self.onCopyText.JSON;
        text[@"copy"] = self.onLargeText.JSON;
        item[@"text"] = text;
    }
    item[@"quicklookurl"] = self.quicklookurl;
    return item;
}

- (NSXMLElement *)XMLElement {
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    
    //  Item Attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[@"uid"] = self.uid;
    attributes[@"arg"] = self.arg;
    attributes[@"valid"] = AKBOOLGetName(self.valid);
    attributes[@"autocomplete"] = self.autocomplete;
    attributes[@"type"] = AKItemTypeGetName(self.type);
    [item setAttributesWithDictionary:attributes];
    
    //  Item Elements
    [item ak_addChild:[NSXMLElement ak_elementWithName:@"title" stringValue:self.title]];
    [item ak_addChild:[NSXMLElement ak_elementWithName:@"subtitle" stringValue:self.subtitle]];
    for (AKItemSubtitle *subtitle in self.subtitles) {
        [item ak_addChild:subtitle.XMLElement];
    }
    for (AKItemModifier *mod in self.mMods.allValues) {
        [item ak_addChild:mod.XMLElement];
    }
    [item ak_addChild:[NSXMLElement ak_elementWithName:@"arg" stringValue:self.arg]];
    [item ak_addChild:self.onCopyText.XMLElement];
    [item ak_addChild:self.onLargeText.XMLElement];
    [item ak_addChild:[NSXMLElement ak_elementWithName:@"quicklookurl" stringValue:self.quicklookurl]];
    [item ak_addChild:self.icon.XMLElement];
    return item;
}

#pragma mark - Lazy Load

@synthesize mMods = _mMods;
- (NSMutableDictionary *)mMods {
    if (!_mMods) {
        _mMods = [NSMutableDictionary dictionary];
    }
    return _mMods;
}

@synthesize mSubtitles = _mSubtitles;
- (NSMutableArray *)mSubtitles {
    if (!_mSubtitles) {
        _mSubtitles = [NSMutableArray array];
    }
    return _mSubtitles;
}

@synthesize icon = _icon;
- (AKItemIcon *)icon {
    if (!_icon) {
        _icon = [[AKItemIcon alloc] init];
    }
    return _icon;
}

@synthesize onCopyText = _onCopyText;
- (AKItemText *)onCopyText {
    if (!_onCopyText) {
        _onCopyText = [AKItemText textWithType:AKItemTextTypCopy];
    }
    return _onCopyText;
}

@synthesize onLargeText = _onLargeText;
- (AKItemText *)onLargeText {
    if (!_onLargeText) {
        _onLargeText = [AKItemText textWithType:AKItemTextTypeLargeType];
    }
    return _onLargeText;
}

@end
