//
//  NewsCommentApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/4.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const commentUrl = @"/comment/api/add";

@interface NewsCommentApi : BaseApi

@property (strong, nonatomic) NSString * _Nullable content;


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
