//
//  TencentAdModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TencentAdModel.h"
#import "GDTNativeAd.h"

@implementation TencentAdModel

/**
 原生广告

 @param dictionary <#dictionary description#>
 @return <#return value description#>
 */
+ (instancetype)tencentAdWithDictionary:(NSDictionary *)dictionary
{
    return [[TencentAdModel alloc] initWithSourceData:dictionary];
    
}

- (id)initWithSourceData:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.title = [dictionary objectForKey:GDTNativeAdDataKeyTitle];
        self.desc = [dictionary objectForKey:GDTNativeAdDataKeyDesc];
        self.iconUrl = [dictionary objectForKey:GDTNativeAdDataKeyIconUrl];
        self.imgUrl = [dictionary objectForKey:GDTNativeAdDataKeyImgUrl];
        self.source = tencentAdType;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        self.created_at = [formatter stringFromDate:[NSDate date]];
    }
    return self;

}

@end
