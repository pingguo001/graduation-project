//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseDelegate.h"
#import "NetworkRequest.h"

/**
 *  设计本协议是为了约束子类的行为，这个协议规范了子类必须要实现的方法
 */
@protocol Api <NSObject>
@required
/**
 *  获取Api请求的URL
 *
 *  @return URL
 */
- (NSString *_Nonnull)url;

/**
 *  获取Api请求的参数
 *
 *  @return 参数
 */
- (NSDictionary *_Nullable)params;

/**
 *  获取Api请求后的回调
 *
 *  @return 回调
 */
- (id<ResponseDelegate> _Nonnull)delegate;

/**
 *  调用Api的方法
 */
- (void)call;

@end

@interface BaseApi : NSObject <ResponseDelegate>

/**
 *  根据优先级发送请求
 *
 *  @param priority 优先级，是-20～20的数，数字越大，优先级越高
 *  @param type     请求的类型，Get、Post
 */
- (void)sendWithType:(Type)type priority:(Priority)priority;

/**
 *  根据优先级发送请求
 *
 *  @param type      请求的类型，Get、Post
 *  @param priority  优先级，是-20～20的数，数字越大，优先级越高
 *  @param interrupt 是否需要打断模式
 *
 */
- (void)sendWithType:(Type)type priority:(Priority)priority interrupt:(BOOL)interrupt;
@end

@interface BaseApi(ParamsGenerator)

/**
 *  生成非加密请求的请求参数
 *
 *  @param query 真正的请求参数，这部分是未加密的
 *
 *  @return 非加密的请求参数
 */
- (NSDictionary *_Nonnull)plainParamsWithQuery:(NSDictionary *_Nonnull)query;

/**
 *  生成加密请求的请求参数
 *
 *  @param query 真正的请求参数，这部分是加密的
 *
 *  @return 加密的请求参数
 */
- (NSDictionary *_Nonnull)cipherParamsWithQuery:(NSDictionary *_Nonnull)query;

/**
 *  生成加密请求的请求参数(ICC)
 *
 *  @param query 真正的请求参数，这部分是加密的
 *
 *  @return 加密的请求参数
 */
- (NSDictionary *_Nullable)cipherParamsICCWithQuery:(NSDictionary *_Nullable)query;

/**
 *  生成真正的请求参数
 *
 *  @param params 除了所有请求共有的请求参数，外部传进来的额外的请求参数
 *
 *  @return 真正的请求参数
 */
- (NSDictionary *_Nonnull)queryWithParams:(NSDictionary *_Nullable)params;

@end
