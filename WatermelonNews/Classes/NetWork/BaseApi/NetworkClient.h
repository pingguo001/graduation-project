//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkRequest;
@protocol ResponseDelegate;

@interface NetworkClient : NSObject

/**
 *  异步的Post请求
 *
 *  @param request  请求对象，是NetworkRequest的实例
 *  @param delegate 请求对调，遵循ResponseDelegate协议
 *
 *  @return NSURLSessionDataTask对象，通过这个对象可以查询到当前请求的状态，取消请求等
 */
- (NSURLSessionDataTask *_Nonnull)post:(NetworkRequest *_Nonnull)request
                          withDelegate:(id <ResponseDelegate> _Nonnull)delegate;

/**
 *  异步的Get请求
 *
 *  @param request  请求对象，是NetworkRequest的实例
 *  @param delegate 请求对调，遵循ResponseDelegate协议
 *
 *  @return NSURLSessionDataTask对象，通过这个对象可以查询到当前请求的状态，取消请求等
 */
- (NSURLSessionDataTask *_Nonnull)get:(NetworkRequest *_Nonnull)request
                 withDelegate:(id <ResponseDelegate> _Nonnull)delegate;

@end