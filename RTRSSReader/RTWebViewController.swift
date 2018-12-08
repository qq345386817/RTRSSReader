//
//  RTWebViewController.swift
//  RTRSSReader
//
//  Created by 罗培克 on 2018/4/21.
//  Copyright © 2018年 ikangtai.com. All rights reserved.
//

import UIKit
import SafariServices

class RTWebViewController: SFSafariViewController {

    init(url URL: URL) {
        if #available(iOS 11.0, *) {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = true
            configuration.barCollapsingEnabled = true
            super.init(url: URL, configuration: configuration)
        } else {
            // Fallback on earlier versions
            super.init(url: URL, entersReaderIfAvailable: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
