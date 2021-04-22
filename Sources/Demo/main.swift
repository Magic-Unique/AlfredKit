//
//  File.swift
//  
//
//  Created by 吴双 on 2021/4/21.
//

import Foundation
import AlfredKit

var scriptFilter = ScriptFilter(xml: true)
scriptFilter.rerun = 1
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
    row.text.largetype = "largetype"
    row.text.copy = "copy"
    row.quicklookurl = "https://www.baidu.com"
}
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
    row.onPress(.alt, subtitle: "Press `Alt`")
}
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
    row.valid = false
}
scriptFilter.variables["aa"] = "bb"

scriptFilter.show()
