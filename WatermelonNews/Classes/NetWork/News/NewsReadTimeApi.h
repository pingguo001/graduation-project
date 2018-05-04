//
//  NewsReadTimeApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/4.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const readTimeUrl = @"/article/api/readTime";

@interface NewsReadTimeApi : BaseApi

@property (copy, nonatomic) NSString * _Nullable duration;
@property (copy, nonatomic) NSString * _Nullable type;


/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate articleId:(NSString *_Nullable)articleId;

/**
 *  调用请求
 */
- (void)call;

@end
