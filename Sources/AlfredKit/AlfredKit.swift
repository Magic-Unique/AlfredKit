
import Foundation

public typealias ScriptFilterJSON = [String: Any]
public typealias ScriptFilterXMLElement = XMLElement

protocol ScriptFilterElement {
    
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
        public var arg: String?
        public var valid: Bool?
        public var autocomplete: String?
        public var match: String?
        public var quicklookurl: String?
        
        public enum Icon {
            case path(String)
            case file(String)
            case type(String)
        }
        public var icon: Icon?
        
        public enum RowType {
            case `default`
            case file(Bool)
            
            var name: String {
                if case let .file(skipcheck) = self {
                    return skipcheck ? "file:skipcheck" : "file"
                } else {
                    return "default"
                }
            }
        }
        public var type: RowType?
        
        public struct Text {
            public var copy: String?
            public var largetype: String?
            public var enable: Bool { copy != nil || largetype != nil }
            public var copyElement: ScriptFilterXMLElement? { element(type: "copy", text: copy) }
            public var largetypeElement: ScriptFilterXMLElement? { element(type: "largetype", text: largetype) }
            func element(type: String, text: String?) -> ScriptFilterXMLElement? {
                let element = ScriptFilterXMLElement(name: "text", value: text)
                element?.setAttributesWith(["type": type])
                return element
            }
        }
        public var text = Text()
        
        public enum ModifierKey: String {
            case alt, shift, cmd, ctrl, fn
        }
        public struct Mod {
            public var key: ModifierKey
            public var valid: Bool = true
            public var subtitle: String?
            public var arg: String?
        }
        public var mods: [ModifierKey: Mod]?
        public mutating func onPress(_ key: ModifierKey, subtitle: String, arg: String? = nil, valid: Bool = true) {
            if mods == nil { mods = [:] }
            mods![key] = Mod(key: key, valid: valid, subtitle: subtitle, arg: arg)
        }
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
    
    var json: ScriptFilterJSON {
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
    
    var xmlElement: XMLElement {
        let element = XMLElement(name: "output")
        if rerun > 0 {
            let _rerun = XMLElement(name: "rerun", value: "\(rerun)")
            element.add(child: _rerun)
        }
        if self.variables.count > 0 {
            let variables = ScriptFilterXMLElement(name: "variables")
            for (key, value) in self.variables {
                let node = ScriptFilterXMLElement(name: "variable", stringValue: value)
                node.setAttributesWith(["name": key])
                variables.add(child: node)
            }
            element.add(child: variables)
        }
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
    
    var json: ScriptFilterJSON {
        var json = ScriptFilterJSON()
        json["uid"] = uid
        json["title"] = title
        json["subtitle"] = subtitle
        json["arg"] = arg
        json["icon"] = icon?.json
        json["valid"] = valid
        json["match"] = match
        json["autocomplete"] = autocomplete
        json["type"] = type?.name
        json["quicklookurl"] = quicklookurl
        if text.enable {
            var text = [String: String]()
            text["copy"] = self.text.copy
            text["largetype"] = self.text.largetype
            json["text"] = text
        }
        if let modCount = mods?.count, modCount > 0 {
            var mods = ScriptFilterJSON()
            for (key, mod) in self.mods! {
                mods[key.rawValue] = mod.json
            }
            json["mods"] = mods
        }
        return json
    }
    
    var xmlElement: XMLElement {
        let item = XMLElement(name: "item")
        
        //  Item Attributes
        var attributes = [String: String]()
        attributes["uid"] = uid;
        attributes["valid"] = valid == nil ? nil : "\(valid!)"
        attributes["autocomplete"] = autocomplete
        attributes["type"] = self.type?.name
        item.setAttributesWith(attributes)
        
        //  Item Elements
        item.add(child: XMLElement(name: "title", value: title))
        item.add(child: XMLElement(name: "subtitle", value: subtitle))
        item.add(child: XMLElement(name: "arg", value: arg))
        item.add(child: text.copyElement)
        item.add(child: text.largetypeElement)
        item.add(child: XMLElement(name: "quicklookurl", value: quicklookurl))
        item.add(child: self.icon?.xmlElement)
        if let modCount = mods?.count, modCount > 0 {
            for (_, mod) in self.mods! {
                item.add(child: mod.xmlElement)
            }
        }
        
        return item;
    }
    
}

extension ScriptFilter.Row.Icon: ScriptFilterElement {
    
    var json: ScriptFilterJSON {
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
    
    var xmlElement: ScriptFilterXMLElement {
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

extension ScriptFilter.Row.Mod: ScriptFilterElement {
    
    var json: ScriptFilterJSON {
        var json = [String:Any]()
        json["valid"] = valid
        json["subtitle"] = subtitle
        json["arg"] = arg
        return json
    }
    
    var xmlElement: ScriptFilterXMLElement {
        let element = ScriptFilterXMLElement(name: "mod")
        // <mod key="shift" subtitle="New subtext when shift is pressed" valid="yes" arg="shiftmod"/>
        var attributes = [String: String]()
        attributes["key"] = key.rawValue
        attributes["subtitle"] = subtitle
        attributes["valid"] = "\(valid)"
        attributes["arg"] = arg
        element.setAttributesWith(attributes)
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
