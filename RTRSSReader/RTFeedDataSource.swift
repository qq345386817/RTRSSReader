//
//  RTFeedDataSource.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit

class RTFeedDataSource: NSObject {
    
    enum Section: Int {
        case feeds = 0, max
    }
    
    var feeds: [String]
    weak var owner: MainViewController?
    
    init(feeds: [String], owner: MainViewController?) {
        self.feeds = feeds
        self.owner = owner
    }
    
}

extension RTFeedDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .feeds: return feeds.count
        case .max: fatalError("Section out of range!")
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .feeds:
            let cell = tableView.dequeueReusableCell(withIdentifier: rtMainVCCellReuseID, for: indexPath)
            cell.textLabel?.text = feeds[indexPath.row]
            return cell
        case .max:
            fatalError("Section out of range!")
        }
    }
}
