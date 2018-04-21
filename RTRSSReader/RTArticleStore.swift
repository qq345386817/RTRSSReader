//
//  RTArticleStore.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit
import PKHUD

class RTArticleStore: NSObject {
    
    var loadFinished: (([RTArticleModel]) -> Void)?
    var articles = [RTArticleModel]()
    
    func loadArticles(feedURL: String, completion: (([RTArticleModel]) -> Void)?) {
        self.loadFinished = completion
        let feedParser = MWFeedParser(feedURL: URL(string: feedURL)!)
        feedParser?.delegate = self
        feedParser?.parse()
    }
    
}

extension RTArticleStore: MWFeedParserDelegate {
    func feedParserDidStart(_ parser: MWFeedParser!) {
        PKHUD.sharedHUD.show()
        articles = [RTArticleModel]()
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        PKHUD.sharedHUD.hide()
        loadFinished?(articles)
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info)
        
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        let model = RTArticleModel(item)
        articles.append(model)
    }
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print(error)
    }
}
