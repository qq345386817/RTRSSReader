//
//  RTArticlesViewController.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit
import SafariServices

let rtArticlesVCCellReuseID = "RTArticlesVCCellReuseID"

class RTArticlesViewController: UIViewController {
    enum Action: ActionType {
        case loadArticles
        case showArticles(articles: [RTArticleModel])
    }
    
    enum Command: CommandType {
        case loadArticles(completion: ([RTArticleModel]) -> Void)
    }
    
    struct State: StateType {
        var dataSource = RTArticlesDataSource(articles: [RTArticleModel](), owner: nil)
    }
    
    var store: Store<Action, State, Command>!
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = {
        [weak self] (state: State, action: Action) in
        
        var state = state
        var command: Command? = nil
        
        switch action {
        case .loadArticles:
            command = Command.loadArticles(completion: { (items) in
                self?.store.dispatch(.showArticles(articles: items))
            })
        case .showArticles(let items):
            state.dataSource = RTArticlesDataSource(articles: items, owner: state.dataSource.owner)
        }
        
        return (state, command)
    }
    
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        if let command = command {
            switch command {
            case .loadArticles(let handler):
                RTArticleStore().loadArticles(feedURL: feedURL, completion: handler)
            }
        }
        
        if previousState == nil || previousState!.dataSource.articles != state.dataSource.articles {
            tableView.dataSource = state.dataSource
            tableView.reloadData()
        }
    }
    
    let cellHeight: CGFloat = 100
    fileprivate lazy var tableView: UITableView = {
        let result = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        result.delegate = self
        result.estimatedSectionHeaderHeight = 0
        result.estimatedSectionFooterHeight = 0
        result.separatorInset = UIEdgeInsets.zero
        result.register(UITableViewCell.self, forCellReuseIdentifier: rtArticlesVCCellReuseID)
        return result
    }()
    
    var feedURL: URL
    
    init(feedURL: URL) {
        self.feedURL = feedURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let dataSource = RTArticlesDataSource(articles: [RTArticleModel](), owner: self)
        let initialState = State(dataSource: dataSource)
        store = Store<Action, State, Command>(reducer: reducer,
                                              initialState: initialState)
        store.subscribe { [weak self] (state, previousState, command) in
            self?.stateDidChanged(state: state, previousState: previousState, command: command)
        }
        stateDidChanged(state: store.state, previousState: nil, command: nil)
        setupNavigationItem()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.dispatch(.loadArticles)
    }
    
    deinit {
        print(NSStringFromClass(type(of: self)) + "---" + #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupNavigationItem() {
        title = "Articles"
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

extension RTArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = RTArticlesDataSource.Section(rawValue: indexPath.section) else {
            fatalError("Section out of range!")
        }
        switch section {
        case .articles:
            let article = store.state.dataSource.articles[indexPath.row]
            let url = URL(string: article.link!)
            let webVC = RTWebViewController(url: url!)
            present(webVC, animated: true, completion: nil)
        case .max:
            fatalError("Section out of range!")
        }
    }
}
