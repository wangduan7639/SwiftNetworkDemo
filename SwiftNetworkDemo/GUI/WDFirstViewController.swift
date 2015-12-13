//
//  WDFirstViewController.swift
//  SwiftNetworkDemo
//
//  Created by wd on 15/12/1.
//  Copyright © 2015年 wd. All rights reserved.
//

import UIKit
import SnapKit

class WDFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor();
        self.tableView = UITableView.init()
        self.view.addSubview(self.tableView)

        self.tableView .snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "IdentCell")
        
    }

    //warning sdf
    @available(iOS, deprecated=1.0, message="I'm not deprecated, please ***didReceiveMemoryWarning**")
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: -UITableViewDelegate 
//TODO: -UITableViewDataSource
//FIXME: sdfsfsdfsd
    //WARNING: sdfsdfsdfsdfsdfsd

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let identCell: NSString = "identCell"
        let cell = tableView .dequeueReusableCellWithIdentifier("IdentCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "Hello world!"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}