//
//  WDNetWorkManager.swift
//  SwiftNetworkDemo
//
//  Created by wangduan on 15/12/13.
//  Copyright © 2015年 wd. All rights reserved.
//

import Foundation
import Alamofire

public class WDNetWorkManager {

    //MARK: 单行单例，默认init()初始化。
    static let sharedInstance = WDNetWorkManager()
    private init() {
        NSLog("init")
    }
    
    private func baseURL(isTest: Bool) ->String{
        if isTest{
            return "https://httpbin.org"
        }
        return "https://httpbin.org"
    }
    
    //MARK: request
    internal func requestModel<T: WDModel>(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, success: (T) -> Void, failure: (NSError?) -> Void) {
    
        let urlString = self.baseURL(true).stringByAppendingString(URLString.URLString)
        
        Alamofire.request(method, urlString,parameters: parameters, encoding: ParameterEncoding.JSON).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("获取数据失败")
                return
            }
            if let dict = response.result.value as? NSDictionary {
                if let model = T(dictionary: dict as [NSObject : AnyObject]) {
                    success(model)
                    return
                }
            }
            failure(response.result.error)
        }
    }
}