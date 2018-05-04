//
//  ImeiLoginApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const imeiLoginUrl = @"/user/api/imeiLogin";

@interface ImeiLoginApi : BaseApi

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
