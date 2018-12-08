//
//  RTArticlesDataSource.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit
import Kingfisher

class RTArticlesDataSource: NSObject {
    
    enum Section: Int {
        case articles = 0, max
    }
    
    var articles: [RTArticleModel]
    var owner: RTArticlesViewController?
    
    init(articles: [RTArticleModel], owner: RTArticlesViewController?) {
        self.articles = articles
        self.owner = owner
    }
    
}

extension RTArticlesDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .articles: return articles.count
        case .max: fatalError("Section out of range!")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .articles:
            let cell = tableView.dequeueReusableCell(withIdentifier: rtArticlesVCCellReuseID, for: indexPath)
            let model = articles[indexPath.row]
            cell.textLabel?.text = model.title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
            cell.textLabel?.numberOfLines = 0
            
            cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            let placehold = URL(fileURLWithPath: "logo.png")
            let resource = ImageResource(downloadURL: model.imgURL ?? placehold, cacheKey: nil)
            cell.imageView?.kf.setImage(with: resource)
            return cell
        case .max: fatalError("Section out of range!")
        }
    }
}
