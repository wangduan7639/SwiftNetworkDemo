//
//  ViewController.swift
//  SwiftNetworkDemo
//
//  Created by wd on 15/11/30.
//  Copyright © 2015年 wd. All rights reserved.
//

import UIKit

class WDViewController: UIViewController {

    var tabMenu :WDTabMenuView!;
    var tabScrollView :WDTabScrollView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor();
        self.tabMenu = WDTabMenuView.init(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, 44), menuItems: ["First", "Second", "Third"], fontsize: 16.0, itemNormalColor: UIColor.blackColor(), itemSelectedColor: UIColor.blueColor(), delegate: self, lineViewColor: UIColor.blueColor());
        self.view.addSubview(self.tabMenu);
        
        self.tabScrollView = WDTabScrollView.init(frame: CGRectMake(0,64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64));
        self.tabScrollView.delegate = self;
        self.tabScrollView.tabViews = [WDFirstViewController(),WDSecondViewController(),WDThirdViewController()];
        self.tabScrollView.tableView.reloadData();
        self.view.addSubview(self.tabScrollView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WDViewController :WDTabMenuViewDelegate{
    
    func selectIndex(index: Int) {
        
        self.tabScrollView?.scrollToView(index);
    }
}

extension WDViewController :WDTabScrollViewDelegate{
    
    func viewSelectedIndex(Index: Int) {
        
        self.tabMenu?.selectIndex(Index);
    }
}
