//
//  AKList.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKList.h"

@interface AKList ()

@property (nonatomic, strong, readonly) NSMutableArray *mItems;

@end

@implementation AKList

+ (instancetype)XMLList {
    AKList *list = [[self alloc] init];
    list.useXMLMode = YES;
    return list;
}

+ (instancetype)JSONList {
    AKList *list = [[self alloc] init];
    list.useXMLMode = NO;
    return list;
}

- (void)addItems:(NSArray *)items {
    NSParameterAssert(items);
    if (items.count) {
        [self.mItems addObjectsFromArray:items];
    }
}

- (void)addItemWithCreator:(AKItemCreator)creator {
    NSParameterAssert(creator);
    [self addItem:[AKItem itemWithCreator:creator]];
}

- (void)addItem:(AKItem *)item {
    NSParameterAssert(item);
    [self.mItems addObject:item];
}

- (void)show {
    NSString *content = nil;
    if (self.useXMLMode) {
        NSXMLDocument *output = [NSXMLDocument documentWithRootElement:[self XMLElement]];
        content = [output XMLString];
    } else {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self JSON]
                                                       options:kNilOptions
                                                         error:nil];
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    printf("%s\n", content.UTF8String);
}

#pragma mark - AKContent

- (id)JSON {
    NSMutableArray *items = [NSMutableArray array];
    for (AKItem *item in self.mItems) {
        [items addObject:[item JSON]];
    }
    NSDictionary *JSON = @{@"items": items};
    return JSON;
}

- (NSXMLElement *)XMLElement {
    NSXMLElement *root = [NSXMLElement elementWithName:@"items"];
    for (AKItem *item in self.mItems) {
        [root addChild:item.XMLElement];
    }
    return root;
}

@synthesize mItems = _mItems;
- (NSMutableArray *)mItems {
    if (!_mItems) {
        _mItems = [[NSMutableArray alloc] init];
    }
    return _mItems;
}

@end

