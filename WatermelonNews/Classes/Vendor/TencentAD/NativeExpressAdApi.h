//
//  NativeExpressAdApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/18.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

//原生模板广告

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "TencentAdModel.h"

#define kAd1Height adaptNormalHeight1334(610)
#define kAd2Height 90


@protocol NativeExpressAdApiDelegate <NSObject>

- (void)nativeExpressAdDidFetchSuccess:(NSArray *)dataArray;
- (void)nativeExpressAdDidFetchFailure:(NSError *)error;

@end

@interface NativeExpressAdApi : NSObject

/**
 初始化原生模板广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initTencentAdWithDelegate:(id<NativeExpressAdApiDelegate>)delegate;

/**
 拉取原生模板广告数据
 */
- (void)fetchNativeExpressAd;

@end
