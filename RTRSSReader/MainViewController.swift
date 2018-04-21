//
//  MainViewController.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit
import SnapKit

let rtMainVCCellReuseID = "RTMainVCCellReuseID"

class MainViewController: UIViewController {
    enum Action: ActionType {
        case loadFeeds
        case showFeeds(feeds: [String])
    }
    
    enum Command: CommandType {
        case loadFeeds(completion: ([String]) -> Void)
    }
    
    struct State: StateType {
        var dataSource = RTFeedDataSource(feeds: [], owner: nil)
    }
    
    var store: Store<Action, State, Command>!
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = {
        [weak self] (state: State, action: Action) in
        
        var state = state
        var command: Command? = nil
        
        switch action {
        case .loadFeeds:
            command = Command.loadFeeds(completion: { (items) in
                self?.store.dispatch(.showFeeds(feeds: items))
            })
        case .showFeeds(let items):
            state.dataSource = RTFeedDataSource(feeds: items, owner: state.dataSource.owner)
        }
        
        return (state, command)
    }
    
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        if let command = command {
            switch command {
            case .loadFeeds(let handler):
                RTFeedStore.shared.getFeeds(completion: handler)
            }
        }
        
        if previousState == nil || previousState!.dataSource.feeds != state.dataSource.feeds {
            tableView.dataSource = state.dataSource
            tableView.reloadData()
        }
    }
    
    let cellHeight: CGFloat = 100
    fileprivate lazy var tableView: UITableView = {
        let result = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        result.delegate = self
        result.estimatedSectionHeaderHeight = 0
        result.estimatedSectionFooterHeight = 0
        result.separatorInset = UIEdgeInsets.zero
        result.register(UITableViewCell.self, forCellReuseIdentifier: rtMainVCCellReuseID)
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let dataSource = RTFeedDataSource(feeds: [], owner: self)
        let initialState = State(dataSource: dataSource)
        store = Store<Action, State, Command>(reducer: reducer,
                                              initialState: initialState)
        store.subscribe { [weak self] (state, previousState, command) in
            self?.stateDidChanged(state: state, previousState: previousState, command: command)
        }
        stateDidChanged(state: store.state, previousState: nil, command: nil)
        setupNavigationItem()
        prepareUI()
        store.dispatch(.loadFeeds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print(NSStringFromClass(type(of: self)) + "---" + #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationItem() {
        title = "RSS List"
    }
    
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = RTFeedDataSource.Section(rawValue: indexPath.section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .feeds:
            let feedURL = feeds[indexPath.row]
            let targetVC = RTArticlesViewController(feedURL: feedURL)
            navigationController?.pushViewController(targetVC, animated: true)
        case .max:
            fatalError("Section out of range!")
        }
    }
}
