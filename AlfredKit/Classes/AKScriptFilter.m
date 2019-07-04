//
//  AKScriptFilter.m
//  AlfredKit
//
//  Created by Magic-Unique on 2019/2/15.
//

#import "AKScriptFilter.h"

@interface AKScriptFilter ()

@end

@implementation AKScriptFilter

+ (instancetype)XMLScriptFilter {
    AKScriptFilter *list = [[self alloc] init];
    list.useXMLMode = YES;
    return list;
}

+ (instancetype)JSONScriptFilter {
    AKScriptFilter *list = [[self alloc] init];
    list.useXMLMode = NO;
    return list;
}

- (void)addItems:(NSArray *)items {
    NSParameterAssert(items);
    if (items.count) {
        [self.items addObjectsFromArray:items];
    }
}

- (void)addItemWithCreator:(AKItemCreator)creator {
    NSParameterAssert(creator);
    [self addItem:[AKItem itemWithCreator:creator]];
}

- (void)addItem:(AKItem *)item {
    NSParameterAssert(item);
    [self.items addObject:item];
}

- (void)setRerun:(NSTimeInterval)rerun {
    if (rerun > 5) {
        rerun = 5;
    }
    if (rerun < 0.1) {
        rerun = 0.1;
    }
    _rerun = rerun;
}

- (NSString *)__description:(BOOL)pretty {
    NSString *content = nil;
    if (self.useXMLMode) {
        NSXMLDocument *output = [NSXMLDocument documentWithRootElement:[self XMLElement]];
        content = [output XMLStringWithOptions:(pretty?NSXMLNodePrettyPrint:kNilOptions)];
    } else {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self JSON]
                                                       options:(pretty?NSJSONWritingPrettyPrinted:kNilOptions)
                                                         error:nil];
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (void)show {
    [self print];
}

- (void)print {
    NSString *content = [self __description:NO];
    printf("%s\n", content.UTF8String);
}

- (void)prettyPrint {
    NSString *content = [self __description:YES];
    printf("%s\n", content.UTF8String);
}

#pragma mark - AKContent

- (id)JSON {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionary];
    JSON[@"variables"] = self.variables.count ? self.variables : nil;
    JSON[@"items"] = ({
        NSMutableArray *items = [NSMutableArray array];
        for (AKItem *item in self.items) {
            [items addObject:[item JSON]];
        }
        items;
    });
    JSON[@"rerun"] = self.rerun == 0 ? nil : @(self.rerun);
    return [JSON copy];
}

- (NSXMLElement *)XMLElement {
    NSXMLElement *root = [NSXMLElement elementWithName:@"output"];
    if (self.rerun != 0) {
        NSXMLElement *rerun = [NSXMLElement elementWithName:@"rerun" stringValue:@(self.rerun).stringValue];
        [root addChild:rerun];
    }
    if (self.variables.count) {
        NSXMLElement *element = [NSXMLElement elementWithName:@"variables"];
        [self.variables enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            NSXMLElement *subelement = [NSXMLElement elementWithName:@"variable" stringValue:obj];
            [subelement setAttributesWithDictionary:@{@"name":key}];
            [element addChild:subelement];
        }];
        [root addChild:element];
    }
    if (self.items.count) {
        NSXMLElement *items = [NSXMLElement elementWithName:@"items"];
        for (AKItem *item in self.items) {
            [items addChild:item.XMLElement];
        }
        [root addChild:items];
    }
    return root;
}

@synthesize items = _items;
- (NSMutableArray<AKItem *> *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

@synthesize variables = _variables;
- (NSMutableDictionary *)variables {
    if (!_variables) {
        _variables = [[NSMutableDictionary alloc] init];
    }
    return _variables;
}

@end

