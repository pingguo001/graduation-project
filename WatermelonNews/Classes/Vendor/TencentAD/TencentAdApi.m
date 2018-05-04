//
//  TencentADApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#define APPKEY      @"1106417984"
#define PLACEMENTID @"1080215124193862"  //demo ID

#import "TencentAdApi.h"

@interface TencentAdApi ()<GDTNativeAdDelegate>

@property (weak, nonatomic) id<TencentAdApiDelegate>delegate;
@property (strong, nonatomic) GDTNativeAd *nativeAd;

@end

@implementation TencentAdApi

/**
 初始化腾讯广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initTencentAdWithController:(UIViewController *)controller delegate:(id<TencentAdApiDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        _nativeAd = [[GDTNativeAd alloc] initWithAppkey:APPKEY placementId:PLACEMENTID];
        _nativeAd.controller = controller;
        _nativeAd.delegate = self;
    }
    return self;
}

/**
 拉取广告数据
 */
- (void)fetchTencentAd
{
    [_nativeAd loadAd:9];
}

/**
 用户点击了广告

 @param nativeAdData 广告数据对象
 */
- (void)startAd:(TencentAdModel *)nativeAdData{
    
    [_nativeAd clickAd:nativeAdData.raw];
    
}

/**
 开始渲染广告
 */
- (void)startAttachTencentAd:(TencentAdModel *)adData toView:(UIView *)view
{
    [_nativeAd attachAd:adData.raw toView:view];
}

#pragma mark - GDTNativeAdDelegate

- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tencentAdDidFetchSuccess:)]) {
        [self.delegate tencentAdDidFetchSuccess: [self transformModelWithDicArray:nativeAdDataArray]];
    }
}

- (void)nativeAdFailToLoad:(NSError *)error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tencentAdDidFetchFailure:)]) {
        [self.delegate tencentAdDidFetchFailure:error];
    }
}

- (NSArray *)transformModelWithDicArray:(NSArray *)dataArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (GDTNativeAdData *currentAd in dataArray) {
        
        TencentAdModel *model = [TencentAdModel tencentAdWithDictionary:currentAd.properties];
        model.raw = currentAd;
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
