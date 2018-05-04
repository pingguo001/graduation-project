//
//  NewsStatApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/4.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsStatApi.h"

@interface NewsStatApi ()<ResponseDelegate, Api>

@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */
@property (strong, nonatomic) NSString * _Nullable articleCategory;

@end

@implementation NewsStatApi

- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate articleCategory:(NSString *)articleCategory
{
    if (self = [super init]) {
        _delegate = delegate;
        _articleCategory = articleCategory;
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
    return [URL_BASE_NEWS stringByAppendingString:statUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    if (_articleIds == nil) {
        _articleIds = @[];
    }
    if (_videoIds == nil) {
        _videoIds = @[];
    }
    return [self cipherParamsWithQuery:@{@"articles":_articleIds.mj_JSONString,
                                         @"videos" : _videoIds.mj_JSONString,
                                         @"actionType":_actionType,
                                         @"category":_articleCategory}];
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
