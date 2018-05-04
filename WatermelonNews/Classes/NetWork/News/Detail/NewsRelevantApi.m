//
//  NewsRelevantApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/15.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsRelevantApi.h"
#import "UIDevice+Info.h"

@interface NewsRelevantApi ()<ResponseDelegate, Api>

@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */

@end

@implementation NewsRelevantApi

- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_NEWS stringByAppendingString:self.type.integerValue == 2 ? videoRelevantUrl : articleRelevantUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return @{@"page":@"1",
             @"pageSize":@"5",
             @"id":self.encryptId,
             @"udid":[[UIDevice currentDevice] account]};
}

/**
 *  获取请求接口回调
 *
 *  @return 请求回调
 */
- (id<ResponseDelegate> _Nullable)delegate {
    return _delegate;
}

/**
 *  调用请求
 */
- (void)call {
    [self sendWithType:GET priority:PRIORITY_HIGHEST interrupt:YES];
}

@end
