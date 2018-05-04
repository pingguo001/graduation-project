//
//  FetchWechatUserInfoApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/26.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "FetchWechatUserInfoApi.h"



@interface FetchWechatUserInfoApi () <ResponseDelegate, Api>
@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */
@property(nonatomic, strong) NSDictionary *params; /**< 外部传入的请求参数 */

@end

@implementation FetchWechatUserInfoApi


#pragma -
#pragma inialize

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nonnull)delegate
                                   params:(NSDictionary * _Nonnull)params {
    if (self = [super init]) {
        _delegate = delegate;
        _params = params;
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
    return URL_FETCH_WECHAT_USERINFO;
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return _params;
}

/**
 *  获取请求接口回调
 *
 *  @return 请求回调
 */
- (id<ResponseDelegate> _Nonnull)delegate {
    return self;
}

/**
 *  调用请求
 */
- (void)call {
    [self sendWithType:GET priority:PRIORITY_HIGHEST];
}

#pragma -
#pragma ResponseDelegate Protocol Implementation

/**
 *  请求成功时的回调方法
 *
 *  @param request  原始请求
 *  @param response 请求返回值
 */
- (void)request:(NetworkRequest *)request success:(id)response {
    if ([_delegate respondsToSelector:@selector(request:success:)]) {
        [_delegate request:request success:response];
    }
}

/**
 *  请求失败时的回调方法
 *
 *  @param request 原始请求
 *  @param error   错误信息
 */
- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(request:failure:)]) {
        [_delegate request:request failure:error];
    }
}

@end
