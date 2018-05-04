//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkRequest;


@interface RequestScheduler : NSObject

/**
 *  获取单例对象
 *
 *  @return RequestScheduler 单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  加入一个需要处理的请求，默认为非中断模式
 *
 *  @param request 待处理的请求
 */
- (void)enqueueRequest:(NetworkRequest *)request;

/**
 *  加入一个需要处理的请求，可以选择中断、非中断模式，在中断模式下，
 *  且待处理的请求优先级比当前进行中的请求优先级都高，
 *  那么会取消掉所有当前进行中的请求，优先处理这个待处理的请求，而所有被取消的请求，
 *  会重新加入等待中的数组，等待下一次请求；
 *  如果是非中断模式，那么会把这个待处理的请求加入到进行中的数组，与进行中的请求一并处理
 *
 *  @param request   待处理的请求
 *  @param interrupt 是否是中断模式
 */
- (void)enqueueRequest:(NetworkRequest *)request needInterrupt:(BOOL)interrupt;

/**
 *  加入一个需要处理的请求数组，所有请求都为非中断模式
 *
 *  @param requests 待处理的请求数组
 */
- (void)enqueueRequests:(NSArray *)requests;
@end