//
//  TaskListApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/9.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskListApi.h"
#import "UIDevice+Info.h"

@interface TaskListApi() <ResponseDelegate, Api>

@end

@implementation TaskListApi

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_ICC stringByAppendingString:taskListUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self cipherParamsICCWithQuery:[self queryWithParams:nil]];
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
    [self sendWithType:POST priority:PRIORITY_HIGHEST];
}

@end
