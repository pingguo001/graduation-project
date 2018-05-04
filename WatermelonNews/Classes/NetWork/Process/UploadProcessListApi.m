//
//  UploadProcessApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "UploadProcessListApi.h"

static NSString * _Nullable const uploadProcessUrl = @"/v1/task/uploadProcessList";

@interface UploadProcessListApi()  <ResponseDelegate, Api>

@end

@implementation UploadProcessListApi

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_ICC stringByAppendingString:uploadProcessUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self cipherParamsICCWithQuery:[self queryWithParams:_params]];
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

@end
