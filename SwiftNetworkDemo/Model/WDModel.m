//
//  WDModel.m
//  SwiftNetworkDemo
//
//  Created by wangduan on 15/12/13.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "WDModel.h"

@implementation WDModel

- (instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}

//Make all model properties optional (avoid if possible)
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
