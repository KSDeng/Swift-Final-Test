//
//  EventData.swift
//  Final
//
//  Created by DKS_mac on 2019/12/23.
//  Copyright © 2019 dks. All rights reserved.
//

import Foundation

class EventData {
    var title: String       // 标题
    var time: Date          // 发布时间
    var read: Int           // 阅读量
    var href: String        // 详细链接
    
    init(title: String, time: Date, read: Int, href: String) {
        self.title = title
        self.time = time
        self.read = read
        self.href = href
    }
    
    
}
