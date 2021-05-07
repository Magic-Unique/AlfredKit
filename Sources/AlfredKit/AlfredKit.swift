//
//  AlfredKit.swift
//  AlfredKit
//
//  Created by Magic-Unique on 2021/04/21.
//

import Foundation

typealias ScriptFilterJSON = [String: Any]
typealias ScriptFilterXMLElement = XMLElement

protocol ScriptFilterElement {
    
    var json: ScriptFilterJSON { get }
    
    var xmlElement: ScriptFilterXMLElement { get }
    
}

/// ScriptFilter instance
public struct ScriptFilter {
    
    public enum Format {
        case xml, json
    }
    
    /**
     Output format, JSON (default) or XML (deprecated by Alfred)
     
     XML mode is deprecated by Alfred. but the XML format will remain available for legacy use.
     */
    public var format: Format = .json
    
    /// Create ScriptFilter
    /// - Parameter xml: Use XML Mode, default is false
    public init(format: Format = .json) {
        self.format = format
    }
    
    /**
     Variables in result list.
     
     Variables can be passed out of the script filter within a variables object. This is useful for two things. Firstly, these variables will be passed out of the script filter's outputs when actioning a result. Secondly, any variables passed out of a script will be passed back in as environment variables when the script is run within the same session. This can be used for very simply managing state between runs as the user types input or when the script is set to re-run after an interval.
     */
    public var variables = [String: String]()
    
    /**
     Rerun time interval.
     
     Scripts can be set to re-run automatically after an interval using the 'rerun' key with a value of 0.1 to 5.0 seconds. The script will only be re-run if the script filter is still active and the user hasn't changed the state of the filter by typing and triggering a re-run.
     */
    public var rerun: TimeInterval = 0
    
    public struct Row {
        
        /**
         This is a unique identifier for the item which allows help Alfred to learn about this item for subsequent sorting and ordering of the user's actioned results.
         
         It is important that you use the same UID throughout subsequent executions of your script to take advantage of Alfred's knowledge and sorting. If you would like Alfred to always show the results in the order you return them from your script, exclude the UID field.
         */
        public var uid: String?
        
        /**
         The title displayed in the result row. There are no options for this element and it is essential that this element is populated.
         */
        public var title: String?
        
        /**
         The subtitle displayed in the result row. This element is optional.
         */
        public var subtitle: String?
        
        /**
         The argument which is passed through the workflow to the connected output action.
         
         While the arg attribute is optional, it's highly recommended that you populate this as it's the string which is passed to your connected output actions. If excluded, you won't know which result item the user has selected.
         */
        public var arg: String?
        
        /**
         If this item is valid or not. If an item is valid then Alfred will action this item when the user presses return. If the item is not valid, Alfred will do nothing. This allows you to intelligently prevent Alfred from actioning a result based on the current {query} passed into your script.
         
         If you exclude the valid attribute, Alfred assumes that your item is valid.
         */
        public var valid: Bool?
        
        /**
         An optional but recommended string you can provide which is populated into Alfred's search field if the user auto-complete's the selected result (⇥ by default).
         
         If the item is set as "valid": false, the auto-complete text is populated into Alfred's search field when the user actions the result.
         */
        public var autocomplete: String?
        
        /**
         From Alfred 3.5, the match field enables you to define what Alfred matches against when the workflow is set to "Alfred Filters Results". If match is present, it fully replaces matching on the title property.
         
         Note that the match field is always treated as case insensitive, and intelligently treated as diacritic insensitive. If the search query contains a diacritic, the match becomes diacritic sensitive.
         */
        public var match: String?
        
        /**
         A Quick Look URL which will be visible if the user uses the Quick Look feature within Alfred (tapping shift, or cmd+y). Note that quicklookurl will also accept a file path, both absolute and relative to home using ~/.
         */
        public var quicklookurl: String?
        
        /// Row icon
        ///
        /// path, file, type
        public enum Icon {
            case path(String), file(String), type(String)
        }
        
        /**
         The icon displayed in the result row. Workflows are run from their workflow folder, so you can reference icons stored in your workflow relatively.
         
         By omitting the "type", Alfred will load the file path itself, for example a png. By using "type": "fileicon", Alfred will get the icon for the specified path. Finally, by using "type": "filetype", you can get the icon of a specific file, for example "path": "public.png"
         */
        public var icon: Icon?
        
        /// Row type
        ///
        /// `default`: `default`; `file(false)`: `file`; `file(true)`: `file:skipcheck`
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
        
        /**
         By specifying type="file", this makes Alfred treat your result as a file on your system. This allows the user to perform actions on the file like they can with Alfred's standard file filters.
         
         When returning files, Alfred will check if the file exists before presenting that result to the user. This has a very small performance implication but makes the results as predictable as possible. If you would like Alfred to skip this check as you are certain that the files you are returning exist, you can use type="file:skipcheck".
         */
        public var type: RowType?
        
        public struct Text {
            
            /// Text for copy
            public var copy: String?
            
            /// Text for largetype
            public var largetype: String?
            
            var enable: Bool { copy != nil || largetype != nil }
            var copyElement: ScriptFilterXMLElement? { element(type: "copy", text: copy) }
            var largetypeElement: ScriptFilterXMLElement? { element(type: "largetype", text: largetype) }
            func element(type: String, text: String?) -> ScriptFilterXMLElement? {
                let element = ScriptFilterXMLElement(name: "text", value: text)
                element?.setAttributesWith(["type": type])
                return element
            }
        }
        
        /**
         The text element defines the text the user will get when copying the selected result row with ⌘C or displaying large type with ⌘L.
         
         If these are not defined, you will inherit Alfred's standard behaviour where the arg is copied to the Clipboard or used for Large Type.
         */
        public var text = Text()
        
        public enum ModifierKey: String {
            case shift, cmd, ctrl, option = "alt"
        }
        public struct Mod {
            public var key: ModifierKey
            public var valid: Bool = true
            public var subtitle: String?
            public var arg: String?
        }
        /**
         The mod element gives you control over how the modifier keys react. You can now define the valid attribute to mark if the result is valid based on the modifier selection and set a different arg to be passed out if actioned with the modifier.
         
         From Alfred 3.4.1, you can define an icon and variables for each object in the mods object.
         */
        public var mods: [ModifierKey: Mod]?
        
        /// Custom modifier key react.
        /// - Parameters:
        ///   - key: modifier key, alt, shift, cmd, ctrl, fn
        ///   - subtitle: subtitle for react
        ///   - arg: Arg for action, default is nil
        ///   - valid: valid state, default is true
        public mutating func on(press key: ModifierKey, subtitle: String, arg: String? = nil, valid: Bool = true) {
            if mods == nil { mods = [:] }
            mods![key] = Mod(key: key, valid: valid, subtitle: subtitle, arg: arg)
        }
    }
    
    private var _rows = [Row]()
    
    /// All appended rows
    var rows: [Row] { _rows }
    
    /// Append a row into row list
    /// - Parameter row: Row
    public mutating func append(_ row: Row) {
        _rows.append(row);
    }
    
    /// Append a row into row list
    /// - Parameter constructer: Row
    public mutating func append(_ constructer: (inout Row) -> Void) {
        var row = Row()
        constructer(&row)
        append(row)
    }
    
    /// Append rows into row list
    /// - Parameter rows: Array for Row
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
    
    /// Convert content to string
    /// - Parameter pretty: Pretty format
    /// - Returns: String
    func toString(format: Format, pretty: Bool) -> String {
        if format == .xml {
            let document = XMLDocument(rootElement: xmlElement)
            let string = document.xmlString(options: pretty ? .nodePrettyPrint : [])
            return string
        } else {
            let data = try! JSONSerialization.data(withJSONObject: self.json, options: pretty ? .prettyPrinted : [])
            let string = String(data: data, encoding: .utf8)!
            return string
        }
    }
    
    /// Print content to standant output
    /// - Parameter pretty: Pretty format
    func show(format: Format? = nil, pretty: Bool = true) {
        let _format = format ?? self.format
        let string = toString(format: _format, pretty: pretty)
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
    
    convenience init?(name: String, value string: String?) {
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
