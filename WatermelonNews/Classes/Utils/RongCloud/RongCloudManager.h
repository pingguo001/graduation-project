//
//  RongCloudManager.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/5.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongCloudManager : NSObject

+ (instancetype)sharedManager;
- (void)loginRongCloud;

@end
