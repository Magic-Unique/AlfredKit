
import Foundation

public typealias ScriptFilterJSON = [String: Any]
public typealias ScriptFilterXMLElement = XMLElement

public protocol ScriptFilterElement {
    
    var json: ScriptFilterJSON { get }
    
    var xmlElement: ScriptFilterXMLElement { get }
    
}

public struct ScriptFilter {
    
    public var xml = false
    
    public init(xml: Bool = false) {
        self.xml = xml
    }
    
    public var variables = [String: String]()
    
    public var rerun: TimeInterval = 0
    
    public struct Row {
        public var uid: String?
        public var title: String?
        public var subtitle: String?
        
        public enum Icon {
            case path(String)
            case file(String)
            case type(String)
        }
        public var icon: Icon?
    }
    
    private var _rows = [Row]()
    
    var rows: [Row] { _rows }
    
    public mutating func append(_ row: Row) {
        _rows.append(row);
    }
    
    public mutating func append(_ constructer: (inout Row) -> Void) {
        var row = Row()
        constructer(&row)
        append(row)
    }
    
    public mutating func append(_ rows: [Row]) {
        _rows.append(contentsOf: rows)
    }
}

extension ScriptFilter: ScriptFilterElement {
    
    public var json: ScriptFilterJSON {
        var json = ScriptFilterJSON()
        json["variables"] = self.variables.count > 0 ? self.variables : nil;
        json["items"] = { () -> [Any] in
            var items = [Any]()
            items = rows.reduce(items, { (list, row) -> [Any] in
                return list + [row.json]
            })
            return items
        }()
        json["rerun"] = rerun == 0 ? nil : rerun;
        return json
    }
    
    public var xmlElement: XMLElement {
        let element = XMLElement(name: "output")
        if rerun > 0 {
            let _rerun = XMLElement(name: "rerun", value: "\(rerun)")
            element.add(child: _rerun)
        }
//        if (self.variables.count) {
//            NSXMLElement *element = [NSXMLElement elementWithName:@"variables"];
//            [self.variables enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
//                NSXMLElement *subelement = [NSXMLElement elementWithName:@"variable" stringValue:obj];
//                [subelement setAttributesWithDictionary:@{@"name":key}];
//                [element addChild:subelement];
//            }];
//            [root addChild:element];
//        }
        if self.rows.count > 0 {
            let items = XMLElement(name: "items")
            for row in rows {
                items.add(child: row.xmlElement)
            }
            element.add(child: items)
        }
        return element;
    }
    
}

public extension ScriptFilter {
    
    func toString(_ pretty: Bool) -> String {
        if xml {
            let document = XMLDocument(rootElement: xmlElement)
            let string = document.xmlString(options: pretty ? .nodePrettyPrint : [])
            return string
        } else {
            let data = try! JSONSerialization.data(withJSONObject: self.json, options: pretty ? .prettyPrinted : [])
            let string = String(data: data, encoding: .utf8)!
            return string
        }
    }
    
    func show(_ pretty: Bool = true) -> Void {
        let string = toString(pretty)
        print(string)
    }
    
}

extension ScriptFilter.Row: ScriptFilterElement {
    
    public var json: ScriptFilterJSON {
        var json = ScriptFilterJSON()
        json["uid"] = self.uid;
        json["title"] = self.title;
        json["subtitle"] = self.subtitle;
//        json["arg"] = self.arg;
        json["icon"] = self.icon?.json;
//        json["valid"] = @(self.valid);
//        json["match"] = self.match;
//        json["autocomplete"] = self.autocomplete;
//        json["type"] = AKItemTypeGetName(self.type);
//        if (self.mMods.count) {
//            NSMutableDictionary *mods = [NSMutableDictionary dictionary];
//            for (AKItemModifier *mod in self.mMods.allValues) {
//                mods[AKModKeyGetName(mod.key)] = mod.JSON;
//            }
//            json["mods"] = mods;
//        }
//        if (self.onCopyText.text || self.onLargeText.text) {
//            NSMutableDictionary *text = [NSMutableDictionary dictionary];
//            text[@"copy"] = self.onCopyText.JSON;
//            text[@"copy"] = self.onLargeText.JSON;
//            json["text"] = text;
//        }
//        json["quicklookurl"] = self.quicklookurl;
        
        return json
    }
    
    public var xmlElement: XMLElement {
        let item = XMLElement(name: "item")
        
        //  Item Attributes
        var attributes = [String: String]()
        attributes["uid"] = uid;
//        attributes["arg"] = arg;
//        attributes["valid"] = AKBOOLGetName(self.valid);
//        attributes["autocomplete"] = self.autocomplete;
//        attributes["type"] = AKItemTypeGetName(self.type);
        item.setAttributesWith(attributes)
        
        //  Item Elements
        item.add(child: XMLElement(name: "title", value: title))
        item.add(child: XMLElement(name: "subtitle", value: subtitle))
//        for (AKItemSubtitle *subtitle in self.subtitles) {
//            [item ak_addChild:subtitle.XMLElement];
//        }
//        for (AKItemModifier *mod in self.mMods.allValues) {
//            [item ak_addChild:mod.XMLElement];
//        }
//        [item ak_addChild:[NSXMLElement ak_elementWithName:@"arg" stringValue:self.arg]];
//        [item ak_addChild:self.onCopyText.XMLElement];
//        [item ak_addChild:self.onLargeText.XMLElement];
//        [item ak_addChild:[NSXMLElement ak_elementWithName:@"quicklookurl" stringValue:self.quicklookurl]];
        item.add(child: self.icon?.xmlElement)
        return item;
    }
    
}

extension ScriptFilter.Row.Icon: ScriptFilterElement {
    
    public var json: ScriptFilterJSON {
        var json = [String:Any]()
        if case let .path(path) = self {
            json["path"] = path
        }
        else if case let .file(path) = self {
            json["type"] = "fileicon"
            json["path"] = path
        }
        else if case let .type(name) = self {
            json["type"] = "filetype"
            json["path"] = name
        }
        return json
    }
    
    public var xmlElement: XMLElement {
        let element = XMLElement(name: "icon")
        if case let .path(path) = self {
            element.stringValue = path
        }
        else if case let .file(path) = self {
            element.stringValue = path
            element.setAttributesWith(["type": "fileicon"])
        }
        else if case let .type(name) = self {
            element.stringValue = name
            element.setAttributesWith(["type": "filetype"])
        }
        return element
    }
    
}

extension XMLElement {
    
    public convenience init?(name: String, value string: String?) {
        if let value = string {
            self.init(name: name, stringValue: value)
        } else {
            return nil
        }
    }
    
    func add(child: XMLNode?) {
        if let _child = child {
            addChild(_child)
        }
    }
}
