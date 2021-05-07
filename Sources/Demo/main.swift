//
//  File.swift
//  
//
//  Created by 吴双 on 2021/4/21.
//

import Foundation
import AlfredKit

var scriptFilter = ScriptFilter(format: .json)
scriptFilter.rerun = 1
scriptFilter.append {
    $0.title = "Title"
    $0.subtitle = "Subtitle"
    $0.icon = .type("png")
    $0.valid = false
    $0.on(press: .option, subtitle: "Press `option`")
    $0.quicklookurl = "https://www.baidu.com"
    $0.text.largetype = "text.largetype"
}
scriptFilter.variables["aa"] = "bb"
scriptFilter.show(format: .json)
scriptFilter.show(format: .xml)
