//
//  NewsCommentListApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/15.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const commentListUrl = @"/comment/api/list";

@interface NewsCommentListApi : BaseApi

@property (copy, nonatomic) NSString * _Nullable encryptId;
@property (copy, nonatomic) NSString * _Nullable type;
@property (assign, nonatomic) NSInteger page;

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
