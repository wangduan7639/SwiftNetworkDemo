//
//  WDTabMenuView.swift
//  SwiftNetworkDemo
//
//  Created by wd on 15/12/1.
//  Copyright © 2015年 wd. All rights reserved.
//

import UIKit

class WDTabMenuView: UIView {

    var menuItems = [String]();
    var itemNormalColor :UIColor?;
    var itemSelectedColor :UIColor?;
    var lineColor :UIColor?;
    var fontSize :Float? = 14.0;
    var lineView :UIView!;
    var delegate :WDTabMenuViewDelegate?;
    
    private var items = [UIButton]();
    private var currentItem :UIButton!;
    
    convenience init(frame: CGRect,
        menuItems: [String],
        fontsize: Float?,
        itemNormalColor: UIColor?,
        itemSelectedColor: UIColor?,
        delegate:WDTabMenuViewDelegate?,
        lineViewColor:UIColor?) {
            self.init(frame:frame);
            self.menuItems = menuItems;
            self.fontSize = fontsize;
            self.itemNormalColor = itemNormalColor;
            self.itemSelectedColor = itemSelectedColor;
            self.delegate = delegate;
            self.lineColor = lineViewColor;
            
            let itemWidth = frame.size.width/CGFloat(menuItems.count);
            let itemHeight = frame.size.height-2;
            
            self.lineView = UIView(frame:CGRectMake(0,itemHeight, itemWidth, 2));
            self.lineView.backgroundColor = lineColor;
            if let lColor = self.lineColor{
                self.lineView.backgroundColor = lColor;
            }else{
                self.lineView.backgroundColor = UIColor.blueColor();
            }
            self.addSubview(self.lineView);
            
            for (index,topic) in menuItems.enumerate(){
                let item = UIButton(type: .Custom);
                items.append(item);
                item.setTitle(topic, forState: .Normal);
                
                if let normalcolor = self.itemNormalColor{
                    item.setTitleColor(normalcolor, forState: .Normal);
                }else{
                    item.setTitleColor(UIColor.blackColor(), forState: .Normal);
                }
                
                
                if let selectcolor = self.itemSelectedColor{
                    item.setTitleColor(selectcolor, forState: .Selected);
                }else{
                    item.setTitleColor(UIColor.redColor(), forState: .Selected);
                }
                
                if let size = self.fontSize {
                    
                    item.titleLabel?.font = UIFont.boldSystemFontOfSize(CGFloat(size));
                }else{
                    item.titleLabel?.font = UIFont.boldSystemFontOfSize(14.0);
                }
                
                
                item.frame = CGRectMake(CGFloat(index)*itemWidth, 0, itemWidth, itemHeight);
                
                if index==0{
                    [self .selectIndex(index)];
                }
                
                item.tag = index;
                
                item.addTarget(self, action: Selector("itemAction:"), forControlEvents: .TouchUpInside);
                
                
                self.addSubview(item);
            }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func itemAction(item: UIButton){
        self.selectIndex(item.tag);
    }
    func selectIndex(index: Int){
        
        if let button = currentItem{
            button.selected = false;
        }
        self.currentItem = items[index];
        
        self.currentItem.selected = true;
        
        let itemWidth = frame.size.width/CGFloat(self.menuItems.count);
        
        UIView.animateWithDuration(0.2) { () -> Void in
            
            var fram = self.lineView.frame;
            
            fram.origin.x = CGFloat(index)*itemWidth;
            
            self.lineView.frame = fram;
        };
        
        if (self.delegate != nil ) {
            
            self.delegate!.selectIndex(index);
        }
        
    }
}

protocol WDTabMenuViewDelegate{
    func selectIndex(index:NSInteger);
}