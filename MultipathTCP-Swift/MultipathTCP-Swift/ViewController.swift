//
//  ViewController.swift
//  MultipathTCP-Swift
//
//  Created by 王云刚 on 2018/10/16.
//  Copyright © 2018年 王云刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**
    Simple example from : http://blog.multipath-tcp.org/blog/html/2017/07/05/mptcp_experiments_on_ios_11_beta.html
    */
    func realSendReq() {
        let config = URLSessionConfiguration.ephemeral
        config.multipathServiceType = URLSessionConfiguration.MultipathServiceType.handover
        let session = URLSession(configuration: config)
//        let url = URL(string: "http://multipath-tcp.org/data/uml/vmlinux_64")
//        let task = session.dataTask(with: url!, completionHandler:{
//            
//        })
//        task.resume()
    }
}

