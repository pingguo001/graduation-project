//
//  NewsListApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const listUrl = @"/article/api/list";

typedef NS_ENUM(NSUInteger, OperationType) {
    OperationNext,  /**< 加载旧数据 */
    OperationFresh, /**< 下拉刷新 */
};

@interface NewsListApi : BaseApi

@property (strong, nonatomic) NSString * _Nullable sequence; //文章起始序号
@property (strong, nonatomic) NSString * _Nullable newsType; //新闻类型
@property (assign, nonatomic) OperationType operationType;
@property (strong, nonatomic) NSString * _Nullable videosequence;

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *  @param newsKey 外部传入的请求参数
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate newsKey:(NSString *_Nullable)newsKey;

/**
 *  调用请求
 */
- (void)call;

@end
