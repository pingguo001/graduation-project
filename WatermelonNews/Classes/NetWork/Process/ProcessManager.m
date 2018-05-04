//
//  ProcessManager.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/11.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "ProcessManager.h"
#import "UploadProcessListApi.h"

@interface ProcessManager () <ResponseDelegate>
@property (nonatomic, strong) UploadProcessListApi *api; /**< 调用上传的API */
@end

@implementation ProcessManager

/**
 获取单例对象

 @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance {
    static ProcessManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ProcessManager new];
    });
    return manager;
}

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)init {
    if (self = [super init]) {
        _api = [[UploadProcessListApi alloc] init];
        _api.delegate = self;
    }
    return self;
}


/**
 上传指定进程

 @param processName 要上传的进程名
 */
- (void)uploadProcess:(NSString *_Nonnull)processName {
    [_api setParams:@{@"processes" : @[processName],
                      @"channel" : APPLICATIONCHANNEL}];
    [_api call];
}

/**
 上传做过的任务进行
 
 @param processArray 要上传的进程数组
 */
- (void)uploadProcessArray:(NSMutableArray *_Nullable)processArray
{
    [_api setParams:@{@"processes" : processArray,
                      @"channel" : APPLICATIONCHANNEL}];
    [_api call];
}

#pragma -
#pragma ResponseDelegate Protocol Implementation

/**
 *  上传请求成功时的回调
 *
 *  @param request  原始请求
 *  @param response 返回值
 */
- (void)request:(NetworkRequest *)request success:(id)response {
    // nothing to do
}

/**
 *  上传请求失败时的回调
 *
 *  @param request 原始请求
 *  @param error   错误信息
 */
- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    if (_resolver != nil) {
        [_resolver resolveError:error ofRequest:request];
    }
}

@end
