//
//  ErrorResolver.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/12.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用来处理网络错误的类
 */

@protocol LoginDelegate;
@class NetworkRequest;

@interface ErrorResolver : NSObject
@property (nonatomic, weak) id<LoginDelegate> _Nullable loginDelegate; /**< 调用登录的代理，因为Token过期时需要重新登录 */

/**
 *  处理错误
 *
 *  @param error   待处理的错误
 *  @param request 发生错误的请求
 */
- (void)resolveError:(NSError *_Nonnull)error ofRequest:(NetworkRequest *_Nullable)request;

/**
 *  重新发送发生错误的请求
 */
- (void)resendRequests;

@end
