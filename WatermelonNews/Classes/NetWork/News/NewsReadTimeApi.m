//
//  NewsReadTimeApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/4.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsReadTimeApi.h"

@interface NewsReadTimeApi ()<ResponseDelegate, Api>

@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */
@property (copy, nonatomic) NSString * _Nullable articleId; //新闻id

@end

@implementation NewsReadTimeApi

- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate articleId:(NSString *_Nullable)articleId
{
    if (self = [super init]) {
        _delegate = delegate;
        _articleId = articleId;
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
    return [URL_BASE_NEWS stringByAppendingString:readTimeUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    if (_type == nil) {
        _type = @"1";
    }
    return [self cipherParamsWithQuery:@{@"articleId" : _articleId,
                                         @"type"      : _type,
                                         @"time"      : _duration}];
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

@end
