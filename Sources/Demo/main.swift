//
//  File.swift
//  
//
//  Created by 吴双 on 2021/4/21.
//

import Foundation
import AlfredKit

var scriptFilter = ScriptFilter(xml: false)
scriptFilter.rerun = 1
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
}
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
}
scriptFilter.append { (row) in
    row.title = "Title"
    row.subtitle = "Subtitle"
    row.icon = .type("png")
}

scriptFilter.show()
