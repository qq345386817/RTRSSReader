//
//  RTFeedStore.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import Foundation
import CloudKit

struct RTFeedStore {
    static let shared = RTFeedStore()
    func getFeeds(completion: (([RTFeed]) -> Void)?) {
        completion?(RTFeed.feeds)
    }
}

class RTDataManager {
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func saveFeed(toCloud: RTFeed) -> Bool {
        return false
    }
}


