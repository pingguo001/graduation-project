//
//  LoginApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "LoginApi.h"
#import "AppInfo.h"
#import <UIKit/UIDevice.h>

@interface LoginApi() <ResponseDelegate, Api>

@end

@implementation LoginApi

#pragma -
#pragma inialize

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate {
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
    return URL_LOGIN;
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    
    
    return [self cipherParamsWithQuery:[self queryWithParams:[self concatParams:_params]]];
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

/**
 *  添加额外的参数
 *
 *  @param raw 原始从外部传进来的参数
 *
 *  @return 添加好之后的参数结果
 */
- (NSDictionary *_Nonnull)concatParams:(NSDictionary *_Nullable)raw {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:10];
    if (raw != nil) {
        [paramDic setDictionary:raw];
    }
    [paramDic setObject:[AppInfo version] forKey:@"app_version"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"sys_version"];
    
    return [paramDic copy];
}

@end
