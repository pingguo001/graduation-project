//
//  TencentAdModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAdView.h"

static NSString * const tencentAdType = @"广告";
static NSString * const expressAdType = @"原生模板广告";
static NSString * const adType1 = @"大图原生模板广告";
static NSString * const adType2 = @"左文右图原生模板广告";


@interface TencentAdModel : NSObject

@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *created_at;
@property (strong, nonatomic) GDTNativeExpressAdView *expressAdView;
@property (strong, nonatomic) NSString *expressAdType;
@property (strong, nonatomic) id raw;
@property (assign, nonatomic) BOOL isRead;

+ (instancetype)tencentAdWithDictionary:(NSDictionary *)dictionary;

@end
