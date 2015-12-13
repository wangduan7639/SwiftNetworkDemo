//
//  WDModel.h
//  SwiftNetworkDemo
//
//  Created by wangduan on 15/12/13.
//  Copyright © 2015年 wd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WDModel : JSONModel

@property (nonatomic, strong) NSDictionary<Optional> *args;
@property (nonatomic, strong) NSDictionary<Optional> *headers;
@property (nonatomic, copy) NSString<Optional> *origin;
@property (nonatomic, copy) NSString<Optional> *url;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
