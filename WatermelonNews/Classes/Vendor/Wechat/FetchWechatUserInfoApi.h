//
//  FetchWechatUserInfoApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/26.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

#define URL_FETCH_WECHAT_USERINFO @"https://api.weixin.qq.com/sns/userinfo"

@interface FetchWechatUserInfoApi : BaseApi

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
