//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseDelegate;

/**
 枚举，代表请求的状态
 */
typedef enum State {
    WAITING = 0,    /**< 等待状态，请求未发出 */
    STARTED,        /**< 开始状态，请求已经发出 */
    CANCELED,       /**< 取消状态，请求可能发出后被取消，或是未发出被取消 */
} State;

/**
 枚举，代表请求类型
 */
typedef enum Type {
    NONE = 0,   /**< 无 */
    GET,        /**< Get 方式 */
    POST        /**< Post 方式 */
} Type;

typedef int Priority;   /**< 请求优先级，越高的请求越被先发出，数值处于-20～20之间 */
static const int PRIORITY_HIGHEST = 20;    /**< 最高优先级 */
static const int PRIORITY_HIGHER  = 10;    /**< 较高优先级 */
static const int PRIORITY_MIDDLE  = 0;     /**< 中等优先级 */
static const int PRIORITY_LOWER   = -10;   /**< 较低优先级 */
static const int PRIORITY_LOWEST  = -20;   /**< 最低优先级 */



@interface NetworkRequest : NSObject

@property(nonatomic, strong) NSString *_Nonnull url; /**< 请求的url */
@property(nonatomic, strong) id _Nullable parameters; /**< 请求的参数 */
@property(nonatomic, strong) id <ResponseDelegate> _Nullable delegate; /**< 请求的回调 */
@property(nonatomic, strong) NSURLSessionDataTask *_Nullable session;  /**< 请求的Session */
@property(nonatomic) Priority priority; /**< 请求优先级 */
@property(nonatomic) State state;       /**< 请求状态 */
@property(nonatomic) Type type;         /**< 请求类型 */
@property(nonatomic) NSUInteger retry;  /**< 重试状态，默认为3次 */

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
+ (instancetype _Nonnull)requestWithUrl:(NSString *_Nonnull)url
                             parameters:(id _Nullable)param
                               delegate:(id <ResponseDelegate> _Nullable)delegate
                               priority:(Priority)priority
                                   type:(Type)type;

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
- (instancetype _Nonnull)initWithUrl:(NSString *_Nonnull)url
                          parameters:(id _Nullable)param
                            delegate:(id <ResponseDelegate> _Nullable)delegate
                            priority:(Priority)priority
                                type:(Type)type;

@end
