//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

//#import "AFAutoPurgingImageCache.h"
#import "NetworkRequest.h"
#import "ResponseDelegate.h"

@implementation NetworkRequest

/**
 *  工厂方法，构建请求对象
 *
 *  @param url      请求的url
 *  @param param    请求的参数
 *  @param delegate 请求的回调
 *  @param priority 请求的优先级
 *  @param type     请求的类型
 *
 *  @return 请求对象实例
 */
+ (instancetype _Nonnull)requestWithUrl:(NSString *_Nonnull)url
                             parameters:(id _Nullable)param
                               delegate:(id <ResponseDelegate>)delegate
                               priority:(Priority)priority
                                   type:(Type)type {
    return [[NetworkRequest alloc] initWithUrl:url
                                    parameters:param
                                      delegate:delegate
                                      priority:priority
                                          type:type];
}

/**
 *  初始化方法
 *
 *  @return 请求对象实例
 */
- (instancetype _Nonnull)init {
    if (self = [super init]) {
        _url = nil;
        _parameters = nil;
        _delegate = nil;
        _session = nil;
        _priority = (int) NSIntegerMin;
        _state = WAITING;
        _type = NONE;
        _retry = 0;
    }
    return self;
}

/**
 *  构建请求对象
 *
 *  @param url      请求的url
 *  @param param    请求的参数
 *  @param delegate 请求的回调
 *  @param priority 请求的优先级
 *  @param type     请求的类型
 *
 *  @return 请求对象实例
 */
- (instancetype _Nonnull)initWithUrl:(NSString *_Nonnull)url
                          parameters:(id _Nullable)param
                            delegate:(id <ResponseDelegate>)delegate
                            priority:(Priority)priority
                                type:(Type)type {
    if (self = [super init]) {
        _url = url;
        _parameters = param;
        _delegate = delegate;
        _session = nil;
        _priority = priority;
        _state = WAITING;
        _type = type;
        _retry = 0;
    }
    return self;
}

@end
