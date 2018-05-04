//
// Created by Zhangziqi on 16/4/27.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkRequest;

/**
 *  请求回调的代理
 */
@protocol ResponseDelegate <NSObject>
@required
/**
 *  请求成功的回调
 *
 *  @param request  原始请求
 *  @param response 请求返回值
 */
- (void)request:(NetworkRequest *_Nonnull)request success:(id _Nonnull)response;

/**
 *  请求失败的回调
 *
 *  @param request 原始请求
 *  @param error   错误信息
 */
- (void)request:(NetworkRequest *_Nullable)request failure:(NSError *_Nonnull)error;

@optional
/**
 *  请求的进度
 *
 *  @param request  原始请求
 *  @param progress 进度信息
 */
- (void)request:(NetworkRequest *_Nonnull)request progress:(NSProgress *_Nonnull)progress;
@end