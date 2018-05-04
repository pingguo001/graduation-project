//
//  NewsRelevantApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/15.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const detailUrl = @"/article/detail/preview?id=";
static NSString * _Nullable const articleRelevantUrl = @"/article/api/relevant";
static NSString * _Nullable const videoRelevantUrl = @"/video/api/relevant";

@interface NewsRelevantApi : BaseApi

@property (copy, nonatomic) NSString * _Nullable encryptId;
@property (copy, nonatomic) NSString * _Nonnull type;

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
