//
//  NewsCategoryApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const categoryUrl = @"/article/api/category";

@interface NewsCategoryApi : BaseApi

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
