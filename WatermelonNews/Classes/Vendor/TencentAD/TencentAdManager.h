//
//  TencentAdManager.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TencentAdManager : NSObject

@property (strong, nonatomic) NSMutableArray *adArray;

+ (instancetype)sharedManager;

@end
