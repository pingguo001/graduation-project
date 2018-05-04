//
//  GoogleAdModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GoogleAdModel.h"

@implementation GoogleAdModel

+ (instancetype)googleAdWithNativeAd:(id )nativeAd
{
    if ([nativeAd isKindOfClass:[GADNativeAppInstallAd class]]) {
        
        return [[GoogleAdModel alloc] initWithNativeAppInstallAd:nativeAd];

    } else {
        
        return [[GoogleAdModel alloc] initWithNativeContentAd:nativeAd];
    }
}

- (id)initWithNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd
{
    if (self = [super init]) {
        self.title = nativeAppInstallAd.headline;
        self.desc = nativeAppInstallAd.body;
        self.icon = nativeAppInstallAd.icon.image;
        GADNativeAdImage *firstImage = nativeAppInstallAd.images.firstObject;
        self.img = firstImage.image;
        self.source = GoogleAdType;
        self.raw = nativeAppInstallAd;
    }
    return self;
}

- (id)initWithNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    if (self = [super init]) {
        self.title = nativeContentAd.headline;
        self.desc = nativeContentAd.body;
        GADNativeAdImage *firstImage = nativeContentAd.images.firstObject;
        self.img = firstImage.image;
        self.raw = nativeContentAd;
        self.source = GoogleAdType;
    }
    return self;
}


@end
