//
//  WDTabScrollView.swift
//  SwiftNetworkDemo
//
//  Created by wd on 15/12/1.
//  Copyright © 2015年 wd. All rights reserved.
//

import UIKit

class WDTabScrollView: UIView {

    var tableView :UITableView!;
    var tabViews = [UIViewController]();
    var delegate :WDTabScrollViewDelegate?;
    override init(frame: CGRect){
        super.init(frame: frame);
        self.backgroundColor = UIColor.grayColor();
        tableView = UITableView(frame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width), style: .Plain);
        tableView.center = CGPointMake(self.center.x, self.center.y-64);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 2));
        tableView.bounces = false;
        tableView.scrollsToTop = true;
        tableView.pagingEnabled = true;
        tableView.showsHorizontalScrollIndicator = false;
        tableView.showsVerticalScrollIndicator = false;
        self.addSubview(tableView);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToView(Index:Int){
        
        UIView.animateWithDuration(0.2) { () -> Void in
            
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: Index, inSection: 0), atScrollPosition: .Middle, animated: true);
        }
    }
}

extension WDTabScrollView :UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.bounds.size.width;
    }
}

extension WDTabScrollView :UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tabViews.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let indentifire = "tabIndentifireCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifire);
        
        if (cell == nil){
            cell = UITableViewCell(style: .Default, reuseIdentifier: indentifire);
        }
        cell!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2));
        let ViewController = self.tabViews[indexPath.row];
        ViewController.view.frame = (cell?.bounds)!;
        cell?.selectionStyle = .None;
        cell?.addSubview(ViewController.view);
        
        return cell!;
    }
}

extension WDTabScrollView :UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset);
        
        let index = scrollView.contentOffset.y/UIScreen.mainScreen().bounds.width;
        
        if(self.delegate != nil){
            
            self.delegate?.viewSelectedIndex(Int(index));
        }
        
    }
}

protocol WDTabScrollViewDelegate{
    
    func viewSelectedIndex(Index: Int);
}