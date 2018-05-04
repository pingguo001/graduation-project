//
//  GoogleNativeAdvancedApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GoogleNativeAdvancedApi.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define kNumAdsToLoad 6

static NSString *const GoogleAdUnit = @"ca-app-pub-1420301870017444/1405445314";

@interface GoogleNativeAdvancedApi ()<GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate>

@property (weak, nonatomic) id<GoogleNativeAdvancedApiDelegate>delegate;

@property(nonatomic, strong) GADAdLoader *adLoader;
@property(assign, nonatomic) NSInteger numAdLoadCallbacks; //返回数量
@property(strong, nonatomic) NSMutableArray *adArray;

@end

@implementation GoogleNativeAdvancedApi

/**
 初始化Google广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initGoogleAdWithController:(UIViewController *)controller delegate:(id<GoogleNativeAdvancedApiDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:GoogleAdUnit rootViewController:controller adTypes:@[kGADAdLoaderAdTypeNativeAppInstall,kGADAdLoaderAdTypeNativeContent] options:nil];
        self.adLoader.delegate = self;
    }
    return self;
}

/**
 拉取广告数据
 */
- (void)fetchNativeAdvanced
{
    self.numAdLoadCallbacks = 0;
    self.adArray = [NSMutableArray array];
    [self preLoadNextAdvanced];
}

//预加载处理
- (void)preLoadNextAdvanced
{
    if (self.numAdLoadCallbacks < kNumAdsToLoad) {
        
        [self.adLoader loadRequest:[GADRequest request]];
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //all you ever do with UIKit.. in your case the reloadData call
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(googleNativeAdvancedDidFetchSuccess:)]) {
                [self.delegate googleNativeAdvancedDidFetchSuccess:self.adArray];
            }
        });
        
    }
}

#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@ failed with error: %@", adLoader, error);
    self.numAdLoadCallbacks += 1;
    [self preLoadNextAdvanced];
}

#pragma mark GADNativeAppInstallAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd
{
    self.numAdLoadCallbacks += 1;
    NSLog(@"%@%@", nativeAppInstallAd.headline, nativeAppInstallAd.body);
    [self.adArray addObject:[GoogleAdModel googleAdWithNativeAd:nativeAppInstallAd]];
    [self preLoadNextAdvanced];
}

#pragma mark GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    self.numAdLoadCallbacks += 1;
    NSLog(@"%@%@", nativeContentAd.headline, nativeContentAd.body);
    [self.adArray addObject:[GoogleAdModel googleAdWithNativeAd:nativeContentAd]];
    [self preLoadNextAdvanced];
}

@end
