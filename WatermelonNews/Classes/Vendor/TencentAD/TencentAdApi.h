//
//  TencentADApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeAd.h"
#import "TencentAdModel.h"

@protocol TencentAdApiDelegate <NSObject>

- (void)tencentAdDidFetchSuccess:(NSArray *)dataArray;
- (void)tencentAdDidFetchFailure:(NSError *)error;

@end

@interface TencentAdApi : NSObject

/**
 初始化腾讯广告

 @param delegate 代理
 @return 广告对象
 */
- (id)initTencentAdWithController:(UIViewController *)controller delegate:(id<TencentAdApiDelegate>)delegate;

/**
 拉取广告数据
 */
- (void)fetchTencentAd;

/**
 用户点击了广告
 
 @param nativeAdData 广告数据对象
 */
- (void)startAd:(TencentAdModel *)nativeAdData;

/**
 开始渲染广告
 */
- (void)startAttachTencentAd:(TencentAdModel *)adData toView:(UIView *)view;

@end
