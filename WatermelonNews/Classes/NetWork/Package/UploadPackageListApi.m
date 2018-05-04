//
//  UploadAppListApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "UploadPackageListApi.h"
#import <UIKit/UIDevice.h>
#import "UIDevice+Info.h"

static NSString * _Nullable const uploadPackageUrl = @"/v1/task/uploadPackageList";

@interface UploadPackageListApi()  <ResponseDelegate, Api>

@end

@implementation UploadPackageListApi

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_ICC stringByAppendingString:uploadPackageUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self cipherParamsICCWithQuery:[self queryWithParams:[self concatParams:_params]]];
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
    [self sendWithType:POST priority:PRIORITY_MIDDLE];
}

/**
 *  增加额外的两个参数
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
    [paramDic setObject:[[UIDevice currentDevice] identifier]   forKey:@"identifier"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"ios_version"];
    return [paramDic copy];
}

@end
