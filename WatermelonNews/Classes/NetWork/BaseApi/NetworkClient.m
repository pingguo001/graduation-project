//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "NetworkClient.h"
#import "NetworkRequest.h"
#import "ResponseDelegate.h"

@interface NetworkClient ()
@property(nonatomic, strong) AFHTTPSessionManager *manager; /**< AFNetworking 调用入口 */
@end

@implementation NetworkClient

#pragma -
#pragma initialize

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[self contentTypes]];
        // 设置超时时间
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 8.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    }
    return self;
}

- (NSSet *)contentTypes {
    return [NSSet setWithObjects:
            @"text/json",
            @"text/javascript",
            @"text/html",
            @"text/xml",
            @"text/plain",
            @"application/atom+xml",
            @"application/xml",
            @"application/json",
            @"image/png",
            @"image/jpeg", nil];
}

#pragma -
#pragma request methods

/**
 *  异步的Post请求
 *
 *  @param request  请求对象，是NetworkRequest的实例
 *  @param delegate 请求对调，遵循ResponseDelegate协议
 *
 *  @return NSURLSessionDataTask对象，通过这个对象可以查询到当前请求的状态，取消请求等
 */
- (NSURLSessionDataTask *_Nonnull)post:(NetworkRequest *_Nonnull)request
                          withDelegate:(id <ResponseDelegate> _Nonnull)delegate {
    return [_manager POST:request.url
               parameters:request.parameters
                 progress:^(NSProgress *uploadProgress) {
                     if ([delegate respondsToSelector:@selector(request:progress:)]) {
                         [delegate request:request progress:uploadProgress];
                     }
                 }
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if ([delegate respondsToSelector:@selector(request:success:)]) {
                          [delegate request:request success:responseObject];
                      }
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      if ([delegate respondsToSelector:@selector(request:failure:)]) {
                          [delegate request:request failure:error];
                      }
                  }];
}

/**
 *  异步的Get请求
 *
 *  @param request  请求对象，是NetworkRequest的实例
 *  @param delegate 请求对调，遵循ResponseDelegate协议
 *
 *  @return NSURLSessionDataTask对象，通过这个对象可以查询到当前请求的状态，取消请求等
 */
- (NSURLSessionDataTask *_Nonnull)get:(NetworkRequest *_Nonnull)request
                         withDelegate:(id <ResponseDelegate> _Nonnull)delegate {
    return [_manager GET:request.url
              parameters:request.parameters
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    if ([delegate respondsToSelector:@selector(request:progress:)]) {
                        [delegate request:request progress:downloadProgress];
                    }
                }
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if ([delegate respondsToSelector:@selector(request:success:)]) {
                         [delegate request:request success:responseObject];
                     }
                 }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if ([delegate respondsToSelector:@selector(request:progress:)]) {
                        [delegate request:request failure:error];
                    }
                }];
    
}

@end
