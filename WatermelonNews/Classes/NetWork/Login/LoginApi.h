//
//  LoginApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

#ifdef DEBUG
#define URL_LOGIN @"http://139.129.162.59:8310/v1/user/login"
#else
#define URL_LOGIN @"http://sword-api.daodaohelper.cn/v1/user/login"
#endif

@interface LoginApi : BaseApi

@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */
@property(nonatomic, strong) NSDictionary *_Nullable params; /**< 外部传入的请求参数 */

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate;

/**
 *  调用请求
 */
- (void)call;

@end
