//
//  NewsListApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsListApi.h"

@interface NewsListApi ()<ResponseDelegate, Api>

@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */

@end

@implementation NewsListApi

- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate newsKey:(NSString *_Nullable)newsKey
{
    if (self = [super init]) {
        _delegate = delegate;
        _newsType = newsKey;
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
    return [URL_BASE_NEWS stringByAppendingString:listUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {

    if (_sequence == nil) {
        
        _sequence = @"0";
    }
    if (_videosequence == nil) {
        _videosequence = @"0";
    }
    return [self cipherParamsWithQuery:self.dictionary];
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
    [self sendWithType:POST priority:PRIORITY_HIGHEST interrupt:YES];
}

- (NSDictionary *)dictionary
{
    return @{@"category" : _newsType,
             @"channel"  : _newsType,
             @"oper"     : _operationType == 0 ? @"next" : @"fresh",
             @"sequence" : _sequence,
             @"vsequence" : _videosequence,
             @"mode" : [UserManager currentUser].applicationMode};
}

@end
