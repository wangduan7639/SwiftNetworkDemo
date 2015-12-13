//
//  WDSecondViewController.swift
//  SwiftNetworkDemo
//
//  Created by wd on 15/12/1.
//  Copyright © 2015年 wd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WDSecondViewController: UIViewController {
    
    var getButton: UIButton!
    var postButton: UIButton!
    var parmasButton: UIButton!
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor();
        self.getButton = UIButton.init()
        self.getButton.backgroundColor = UIColor.blackColor()
        self.getButton .setTitle("getRequest", forState: UIControlState.Normal)
        self.getButton.addTarget(self, action: Selector.init("getButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.getButton)
        
        self.postButton = UIButton.init()
        self.postButton.backgroundColor = UIColor.blackColor()
        self.postButton .setTitle("postRequest", forState: UIControlState.Normal)
        self.postButton.addTarget(self, action: Selector.init("postButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.postButton)
        
        self.parmasButton = UIButton.init()
        self.parmasButton.backgroundColor = UIColor.blackColor()
        self.parmasButton .setTitle("paramsRequest", forState: UIControlState.Normal)
        self.parmasButton.addTarget(self, action: Selector.init("paramsButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.parmasButton)

        self.textView = UITextView.init()
        self.textView.textColor = UIColor.redColor()
        self.view.addSubview(self.textView)
        
        self.getButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(130)
            make.height.equalTo(30)
        }
        
        self.postButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.getButton.snp_bottom).offset(20)
            make.centerX.equalTo(self.getButton)
            make.width.height.equalTo(self.getButton)
        }
        
        self.parmasButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.postButton.snp_bottom).offset(20)
            make.centerX.width.height.equalTo(self.postButton)
        }
        
        self.textView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.parmasButton.snp_bottom).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getButtonClicked(sender: UIButton){
        NSLog("getButton")

        //MARK: 直接使用Alamofire返回数据并转化为SwiftJson，
        #if false
        Alamofire.request(.GET, "https://httpbin.org/get").responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("获取数据失败")
                return
            }
            print(response.result.value);
            
            
            print("origin-=---",JSON(response.result.value!)["origin"]);
            print("headers-=---",JSON(response.result.value!)["headers"]["User-Agent"]);
            
            self.textView.text=String(JSON(response.result.value!));
        }
        #endif
        //WARK: 使用JSONModel封装的
        WDNetWorkManager.sharedInstance.requestModel(.GET, "/get", success: { (wdModel: WDModel) -> Void in
            self.textView.text = wdModel.debugDescription
            
        }) { (error) -> Void in
            self.textView.text = error.debugDescription
        }
        
    }
    
    func postButtonClicked(sender: UIButton){
        NSLog("postButton")
        
        //MARK: 直接使用Alamofire返回数据并转化为SwiftJson，
        #if false
            Alamofire.request(.POST, "https://httpbin.org/post").responseJSON { (response) -> Void in
                guard response.result.error == nil else {
                    print("获取数据失败")
                    return
                }
                print(response.result.value);
                
                
                print("origin-=---",JSON(response.result.value!)["origin"]);
                print("headers-=---",JSON(response.result.value!)["headers"]["User-Agent"]);
                
                self.textView.text=String(JSON(response.result.value!));
            }
        #endif
        //WARK: 使用JSONModel封装的
        WDNetWorkManager.sharedInstance.requestModel(.POST, "/post", success: { (wdModel: WDModel) -> Void in
            self.textView.text = wdModel.debugDescription
            
            }) { (error) -> Void in
                self.textView.text = error.debugDescription
        }
    }
    
    func paramsButtonClicked(sender: UIButton){
        //WARK: 使用JSONModel封装的
        WDNetWorkManager.sharedInstance.requestModel(.GET, "/get", parameters: ["foo": "bar"], success: { (wdModel: WDModel) -> Void in
            self.textView.text = wdModel.debugDescription
            
            }) { (error) -> Void in
                self.textView.text = error.debugDescription
        }
    }

}
