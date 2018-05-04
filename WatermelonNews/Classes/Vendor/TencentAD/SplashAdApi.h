//
//  SplashAdApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/14.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSplashAd.h"

//开屏广告

@protocol SplashAdApiDelegate <NSObject>

- (void)splashAdClosed;

@end

@interface SplashAdApi : NSObject

/**
 初始化开屏广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initTencentAdWithDelegate:(id<SplashAdApiDelegate>)delegate;

@end
