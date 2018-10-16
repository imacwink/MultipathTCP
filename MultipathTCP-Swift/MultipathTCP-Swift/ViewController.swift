//
//  ViewController.swift
//  MultipathTCP-Swift
//
//  Created by 王云刚 on 2018/10/16.
//  Copyright © 2018年 王云刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**
    Simple example from : http://blog.multipath-tcp.org/blog/html/2017/07/05/mptcp_experiments_on_ios_11_beta.html
    */
    func realSendReq(_ type : URLSessionConfiguration.MultipathServiceType) {
        let config = URLSessionConfiguration.ephemeral
        config.multipathServiceType = type
        let session = URLSession(configuration: config)
        let stringUrl = "http://amiusingmptcp.de/v1/check_connection"
        let url = URL(string: stringUrl)
        let task = session.dataTask(with: url!, completionHandler: { (data, resp, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
            }
        })
        task.resume()
    }
    
    /*!
     @enum NSURLSessionMultipathServiceType
     
     @discussion The NSURLSessionMultipathServiceType enum defines constants that
     can be used to specify the multipath service type to associate an NSURLSession.  The
     multipath service type determines whether multipath TCP should be attempted and the conditions
     for creating and switching between subflows.  Using these service types requires the appropriate entitlement.  Any connection attempt will fail if the process does not have the required entitlement.
     A primary interface is a generally less expensive interface in terms of both cost and power (such as WiFi or ethernet).  A secondary interface is more expensive (such as 3G or LTE).
     
     @constant NSURLSessionMultipathServiceTypeNone Specifies that multipath tcp should not be used.  Connections will use a single flow.
     This is the default value.  No entitlement is required to set this value.
     */
    @IBAction func SendNoneReq(_ sender: Any) {
        self.realSendReq(URLSessionConfiguration.MultipathServiceType.none)
    }
    
    /**
     @constant NSURLSessionMultipathServiceTypeHandover Specifies that a secondary subflow should only be used
     when the primary subflow is not performing adequately.   Requires the com.apple.developer.networking.multipath entilement.
     */
    @IBAction func SendHandoverReq(_ sender: Any) {
        self.realSendReq(URLSessionConfiguration.MultipathServiceType.handover)
    }
    
    /**
     @constant NSURLSessionMultipathServiceTypeInteractive Specifies that a secodary subflow should be used if the
     primary subflow is not performing adequately (packet loss, high round trip times, bandwidth issues).  The secondary
     subflow will be created more aggressively than with NSURLSessionMultipathServiceTypeHandover.  Requires the com.apple.developer.networking.multipath entitlement.
     */
    @IBAction func SendInteractiveReq(_ sender: Any) {
        self.realSendReq(URLSessionConfiguration.MultipathServiceType.interactive)
    }
    
    /**
    @constant NSURLSessionMultipathServiceTypeAggregate Specifies that multiple subflows across multiple interfaces should be
    used for better bandwidth.  This mode is only available for experimentation on devices configured for development use.
    It can be enabled in the Developer section of the Settings app.
    
    */
    @IBAction func SendAggregateReq(_ sender: Any) {
        self.realSendReq(URLSessionConfiguration.MultipathServiceType.aggregate)
    }
}

