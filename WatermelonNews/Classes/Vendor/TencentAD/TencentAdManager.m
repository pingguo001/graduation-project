//
//  TencentAdManager.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TencentAdManager.h"

@implementation TencentAdManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TencentAdManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [TencentAdManager new];
    });
    return manager;
}

@end
