//
//  RTFeedModel.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/12/8.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit

struct RTFeed {
    let url: URL
    let title: String
    
    static var feeds: [RTFeed] {
        return [RTFeed(url: URL(string: "http://nshipster.cn/feed.xml")!, title: "NSHipster")]
    }
}

extension RTFeed: Equatable {
    static func == (lhs: RTFeed, rhs: RTFeed) -> Bool {
        return lhs.url == rhs.url
            && lhs.title == rhs.title
    }
}
