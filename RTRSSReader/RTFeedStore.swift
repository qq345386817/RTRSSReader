//
//  RTFeedStore.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import Foundation

let feeds = ["http://nshipster.cn/feed.xml"]

struct RTFeedStore {
    static let shared = RTFeedStore()
    func getFeeds(completion: (([String]) -> Void)?) {
        completion?(feeds)
    }
}
