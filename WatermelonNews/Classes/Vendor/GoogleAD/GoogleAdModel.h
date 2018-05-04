//
//  GoogleAdModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

static NSString * const GoogleAdType = @"谷歌原生广告";

@interface GoogleAdModel : NSObject

@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIImage *img;
@property (copy, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *expressAdType;
@property (strong, nonatomic) id raw;
@property (assign, nonatomic) BOOL isRead;

+ (instancetype)googleAdWithNativeAd:(id )nativeAd;

@end
