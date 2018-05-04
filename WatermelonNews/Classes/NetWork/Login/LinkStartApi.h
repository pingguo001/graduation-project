//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"


static NSString * _Nullable const linkStartUrl = @"/v1/user/linkStart";

@interface LinkStartApi : BaseApi

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nonnull)delegate;

/**
 *  调用请求
 */
- (void)call;

@end
