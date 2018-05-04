//
//  FetchNotificationApi.m
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import "FetchNotificationApi.h"

@interface FetchNotificationApi () <ResponseDelegate, Api>

@end

@implementation FetchNotificationApi

#pragma -
#pragma inialize
/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)init {
    if (self = [super init]) {
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
    return URL_FETCH_NOTIFICATION;
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self cipherParamsWithQuery:[self queryWithParams:nil]];
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
    [self sendWithType:POST priority:PRIORITY_MIDDLE interrupt:YES];
}

@end
