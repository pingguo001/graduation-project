//
//  FetchWechatTokenApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@interface FetchWechatTokenApi : BaseApi

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *  @param params 外部传入的请求参数
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nonnull)delegate
                                   params:(NSDictionary *_Nonnull)params;

/**
 *  调用请求
 */
- (void)call;

@end
