//
//  RTArticleModel.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit

class RTArticleModel: NSObject {
    
    var title: String?
    var imgURL: URL?
    var link: String?
    
    init(_ item: MWFeedItem) {
        self.title = item.title
        self.link = item.link
        let projectURL = item.link.components(separatedBy: "?")[0]
        self.imgURL = URL(string: projectURL + "/cover_image?style=200x200#")
    }
}

class RTArticleCell: UITableViewCell {
    
}
