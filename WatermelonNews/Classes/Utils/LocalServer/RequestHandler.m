//
//  RequestHandler.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "RequestHandler.h"
#import "HTTPResponse.h"
#import "HTTPDataResponse.h"
#import "UIDevice+Info.h"
#import "NSDictionary+JSON.h"
#import "UserManager.h"
#import "TaskManager.h"
#import "PackageManager.h"
#import "HTTPAsyncStringResponse.h"
#import "HTTPSyncDataResponse.h"
#import "Task.h"

static NSString *const OPER_FETCH_TASK      = @"fetchTask";
static NSString *const OPER_FETCH_SIGN_TASK = @"fetchSignTask";
static NSString *const OPER_FETCH_DETAIL    = @"fetchDetail";
static NSString *const OPER_START_TASK      = @"startTask";
static NSString *const OPER_START_SIGN_TASK = @"startSignTask";
static NSString *const OPER_SUBMIT_TASK     = @"submitTask";
static NSString *const OPER_CANCEL_TASK     = @"cancelTask";
static NSString *const OPER_CHECK_APP       = @"checkApp";
static NSString *const OPER_OPEN_APP        = @"openApp";
static NSString *const OPER_TRY_OPEN_APP    = @"tryOpenApp";


@interface RequestHandler ()
@property (nonatomic, strong) TaskManager           *taskManager;   /**< 任务管理器 */
@property (nonatomic, weak)   HTTPConnection        *connection;    /**< HTTPConnection 对象 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, HTTPAsyncStringResponse *>   *asyncResponse;
@end

@implementation RequestHandler

/**
 *  初始化
 *
 *  @param connection HTTPConnection实例
 *
 *  @return 类对象
 */
- (instancetype _Nonnull)initWithConnection:(HTTPConnection *_Nonnull)connection {
    if (self == [super init]) {
        _taskManager = [TaskManager defaultManager];
        _asyncResponse = [NSMutableDictionary dictionaryWithCapacity:10];
        _connection = connection;
    }
    return self;
}

/**
 *  判断是否是已知的操作
 *
 *  @param oper 请求操作
 *
 *  @return 是否是已知请求
 */
- (BOOL)isKnownOper:(NSString *)oper {
    return oper != nil &&
    ([oper isEqualToString:OPER_FETCH_TASK] ||
     [oper isEqualToString:OPER_FETCH_SIGN_TASK] ||
     [oper isEqualToString:OPER_START_TASK] ||
     [oper isEqualToString:OPER_START_SIGN_TASK] ||
     [oper isEqualToString:OPER_CANCEL_TASK] ||
     [oper isEqualToString:OPER_FETCH_DETAIL] ||
     [oper isEqualToString:OPER_SUBMIT_TASK] ||
     [oper isEqualToString:OPER_CHECK_APP] ||
     [oper isEqualToString:OPER_OPEN_APP] ||
     [oper isEqualToString:OPER_TRY_OPEN_APP]);
}

/**
 *  处理请求
 *
 *  @param oper  请求操作
 *  @param query 请求内容
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nullable)handleRequest:(NSString *)oper
                                              query:(NSDictionary *)query {
    if ([query[@"e"] isEqualToString:@"0"]) {
        return [self handleUnencryptRequest:oper query:query];
    } else {
        return [self handleEncryptRequest:oper query:query];
    }
}

/**
 *  处理非加密请求
 *
 *  @param oper  请求操作
 *  @param query 请求内容
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nullable)handleUnencryptRequest:(NSString *)oper
                                                       query:(NSDictionary *)query {
    // 取出真正的参数
    NSString *q = [query[@"q"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *realQuery = [NSDictionary dictionaryWithJSON:q];
    
    if ([oper isEqualToString:OPER_FETCH_TASK]) {
        return [self handleFetchFastTasksRequest];
    } else if ([oper isEqualToString:OPER_FETCH_SIGN_TASK]) {
        return [self handleFetchSignTasksRequest];
    } else if ([oper isEqualToString:OPER_FETCH_DETAIL]) {
        return [self handleFetchDetailRequestWithTaskId:realQuery[@"task_id"]];
    } else if ([oper isEqualToString:OPER_START_TASK]) {
        return [self handleStartTaskRequestWithTaskId:realQuery[@"task_id"]];
    } else if ([oper isEqualToString:OPER_START_SIGN_TASK]) {
        return [self handleStartSignTaskRequestWithTaskId:realQuery[@"task_id"]];
    } else if ([oper isEqualToString:OPER_SUBMIT_TASK]) {
        return [self handleSubmitTaskRequestWithTaskId:realQuery[@"task_id"]];
    } else if ([oper isEqualToString:OPER_CHECK_APP]) {
        return [self handleCheckAppRequestWithBundleId:realQuery[@"bundle_id"]];
    } else if ([oper isEqualToString:OPER_OPEN_APP]) {
        return [self handleOpenAppRequestWithBundleId:realQuery[@"bundle_id"]];
    } else if ([oper isEqualToString:OPER_TRY_OPEN_APP]) {
        return [self handleTryOpenAppRequestWithBundleId:realQuery[@"bundle_id"]];
    }
    return nil;
}

/**
 *  处理加密请求，目前没有加密的请求
 *
 *  @param oper  请求操作
 *  @param query 请求内容
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nullable)handleEncryptRequest:(NSString *)oper
                                                     query:(NSDictionary *)query {
    return nil;
}

/**
 *  处理拉取任务列表请求
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleFetchFastTasksRequest {
    
    //从第三方SDK拉取任务，响应给H5页面
    [_taskManager fetchFastTasksWithResponseBlock:^(NSError * _Nullable error, id  _Nullable obj) {
        NSString *responseString = nil;
        if (error != nil && error.code != 0) {
            responseString = [self generateErrorResponseStringWithCode:error.code];
        } else {
            responseString = [self generateSuccessResponseStringWithObj:obj];
        }
        
        HTTPAsyncStringResponse *resp = _asyncResponse[OPER_FETCH_TASK];
        [resp setResponse:responseString];
    }];
    return [self generateAsyncResponseForOper:OPER_FETCH_TASK];
}

/**
 *  处理拉取签到任务请求
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleFetchSignTasksRequest {
    [_taskManager fetchSignTasksWithResponseBlock:^(NSError * _Nullable error, id  _Nullable obj) {
        NSString *responseString = nil;
        if (error != nil && error.code != 0) {
            responseString = [self generateErrorResponseStringWithCode:error.code];
        } else {
            responseString = [self generateSuccessResponseStringWithObj:obj];
        }
        
        HTTPAsyncStringResponse *resp = _asyncResponse[OPER_FETCH_SIGN_TASK];
        [resp setResponse:responseString];
    }];
    
    return [self generateAsyncResponseForOper:OPER_FETCH_SIGN_TASK];
}

/**
 *  处理拉取任务详情请求
 *
 *  @param taskId 要拉取的任务ID
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleFetchDetailRequestWithTaskId:(id _Nonnull)taskId {
    if (![taskId isKindOfClass:[NSString class]]) {
        taskId = [NSString stringWithFormat:@"%@", taskId];
    }
    
    Task *aim = [_taskManager getFastTaskDetailWithTaskId:taskId];
    NSString *response = nil;
    if (aim == nil) {
        response = [self generateErrorResponseStringWithCode:ERROR_TASK_NOT_FOUND];
    } else {
        response = [self generateSuccessResponseStringWithObj:[aim dictionary]];
    }
    return [self generateSyncResponseForData:[response dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 *  处理开始任务请求
 *
 *  @param taskId 要开始的任务ID
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleStartTaskRequestWithTaskId:(id _Nonnull)taskId {
    if (![taskId isKindOfClass:[NSString class]]) {
        taskId = [NSString stringWithFormat:@"%@", taskId];
    }
    
    Task *aim = [_taskManager getFastTaskDetailWithTaskId:taskId];
    [_taskManager startTask:aim withResponseBlock:^(NSError * _Nullable error, id  _Nullable obj) {
        NSString *responseString = nil;
        if (error != nil && error.code != 0) {
            responseString = [self generateErrorResponseStringWithCode:error.code];
        } else {
            responseString = [self generateSuccessResponseStringWithObj:obj];
        }
        
        HTTPAsyncStringResponse *resp = _asyncResponse[OPER_START_TASK];
        [resp setResponse:responseString];
    }];
    return [self generateAsyncResponseForOper:OPER_START_TASK];
}
                
- (NSObject <HTTPResponse> *_Nonnull)handleStartSignTaskRequestWithTaskId:(id _Nonnull)taskId {
    if (![taskId isKindOfClass:[NSString class]]) {
        taskId = [NSString stringWithFormat:@"%@", taskId];
    }
    
    __block NSString *responseString = nil;
    __block BOOL isAsync = YES;
    NSString *threadName = [[NSThread currentThread] name];
    Task *aim = [_taskManager getSignTaskDetailWithTaskId:taskId];
    [_taskManager startTask:aim withResponseBlock:^(NSError * _Nullable error, id  _Nullable obj) {
        if (error != nil && error.code != 0) {
            responseString = [self generateErrorResponseStringWithCode:error.code];
        } else {
            responseString = [self generateSuccessResponseStringWithObj:obj];
        }
        
        if ([threadName isEqualToString:[[NSThread currentThread] name]]) {
            isAsync = NO;
        }
        
        if (isAsync) {
            HTTPAsyncStringResponse *resp = _asyncResponse[OPER_START_SIGN_TASK];
            [resp setResponse:responseString];
        }
    }];
    
    if (isAsync) {
        return [self generateAsyncResponseForOper:OPER_START_SIGN_TASK];
    } else {
        return [self generateSyncResponseForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

/**
 *  处理提交任务请求
 *
 *  @param taskId 要提交任务的ID
 *
 *  @return 请求响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleSubmitTaskRequestWithTaskId:(id _Nonnull)taskId {
    if (![taskId isKindOfClass:[NSString class]]) {
        taskId = [NSString stringWithFormat:@"%@", taskId];
    }
    
    NSObject <HTTPResponse> *response = [self generateAsyncResponseForOper:OPER_SUBMIT_TASK];
    
    Task *aim = [_taskManager getFastTaskDetailWithTaskId:taskId];
    [_taskManager submitTask:aim withResponseBlock:^(NSError * _Nullable error, id  _Nullable obj) {
        NSString *responseString = nil;
        if (error != nil && error.code != 0) {
            responseString = [self generateErrorResponseStringWithCode:error.code];
        } else {
            responseString = [self generateSuccessResponseStringWithObj:obj];
        }
        
        HTTPAsyncStringResponse *resp = _asyncResponse[OPER_SUBMIT_TASK];
        [resp setResponse:responseString];
        
        // code 是402、404时，本block是被同步调用的
        // 这里设置 isChunked 为 NO，让请求直接返回
        // 如果为 YES 那么会崩溃
        if (error != nil && (error.code == 402 || error.code == 404)) {
            [resp setIsChunked:NO];
        }
    }];
    
    return response;
}

/**
 *  处理检查App状态的请求，App状态可能有以下几种
 *  NONEXISTENT 未安装
 *  INSTALLING  安装中，暂时不会返回
 *  INSTALLED   已安装，暂时不会返回
 *
 *  @param bundleId 要检查App的BundleId
 *
 *  @return HTTP响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleCheckAppRequestWithBundleId:(NSString *_Nonnull)bundleId {
    NSDictionary *respDic = @{
                              @"status" : [PackageManager isAppInstalled:bundleId] ? @(YES) : @(NO)
                              };
    NSString *response = [self generateSuccessResponseStringWithObj:respDic];
    return [self generateSyncResponseForData:[response dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 *  根据bundle id打开指定的APP
 *
 *  @param bundleId 要打开App的BundleId
 *
 *  @return HTTP响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleOpenAppRequestWithBundleId:(NSString *_Nonnull)bundleId {
    NSString *response = nil;
    if ([PackageManager openApp:bundleId]) {
        response = [self generateSuccessResponseStringWithObj:nil];
    } else {
        response = [self generateErrorResponseStringWithCode:ERROR_APP_NOT_FOUND];
    }
    return [self generateSyncResponseForData:[response dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 根据 bundle id不断尝试打开指定的App

 @param bundleId 要打开App的BundleId

 @return HTTP响应
 */
- (NSObject <HTTPResponse> *_Nonnull)handleTryOpenAppRequestWithBundleId:(NSString * _Nonnull)bundleId {
    [_taskManager monitorTask:bundleId];
    NSString *response = [self generateSuccessResponseStringWithObj:nil];
    return [self generateSyncResponseForData:[response dataUsingEncoding:NSUTF8StringEncoding]];
}

/*
 *  生成同步请求的HTTP响应
 *
 *  @param data 请求要返回的数据
 *
 *  @return HTTP响应
 */
- (NSObject <HTTPResponse> *_Nonnull)generateSyncResponseForData:(NSData *_Nonnull)data {
    HTTPSyncDataResponse *resp = [[HTTPSyncDataResponse alloc] initWithData:data];
    [resp setHeaders:@{@"Access-Control-Allow-Origin": @"*"}];
    return resp;
}

/*
 *  生成异步请求的HTTP响应
 *
 *  @param oper 请求 oper，用来缓存这个操作
 *
 *  @return HTTP响应
 */
- (NSObject <HTTPResponse> *_Nonnull)generateAsyncResponseForOper:(NSString *_Nonnull)oper {
    HTTPAsyncStringResponse *resp = [HTTPAsyncStringResponse responseWithConnection:_connection];
    [resp setHeaders:@{@"Access-Control-Allow-Origin": @"*"}];
    _asyncResponse[oper] = resp;
    return resp;
}

/**
 *  根据错误码生成相应的响应内容
 *
 *  @param code 错误码
 *
 *  @return 响应内容
 */
- (NSString *_Nonnull)generateErrorResponseStringWithCode:(NSInteger)code {
    NSDictionary *responseDic = @{
                                  @"code"    : @(code),
                                  @"encrypt" : @(0)
                                  };
    return [responseDic json];
}

/**
 *  生成响应内容
 *
 *  @param obj 要加载进响应内容的数据
 *
 *  @return 响应内容
 */
- (NSString *_Nonnull)generateSuccessResponseStringWithObj:(id _Nullable)obj {
    NSDictionary *responseDic = @{
                                  @"code"    : @(0),
                                  @"encrypt" : @(0),
                                  @"data"    : obj == nil ? @{} : obj
                                  };
    return [responseDic json];
}

@end
