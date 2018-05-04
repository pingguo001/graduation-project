//
//  NewsStatApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/4.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

#define STAT_CLICK                 @"click"
#define STAT_PULL                  @"pull"
#define STAT_SHOW                  @"show"
#define STAT_REFRESH               @"refresh"
#define STAT_SHARE_QQ              @"share_qq"
#define STAT_SHARE_QZONE           @"share_qzone"
#define STAT_SHARE_WECHAT          @"share_wechat"
#define STAT_SHARE_MOMENTS         @"share_moments"
#define STAT_SHARE_QQ_SUCCESS      @"share_qq_success"
#define STAT_SHARE_QZONE_SUCCESS   @"share_qzone_success"
#define STAT_SHARE_WECHAT_SUCCESS  @"share_wechat_success"
#define STAT_SHARE_COPY            @"share_copy"

static NSString * _Nullable const statUrl = @"/article/api/stat";

@interface NewsStatApi : BaseApi

@property (strong, nonatomic) NSArray * _Nullable articleIds;
@property (strong, nonatomic) NSArray * _Nullable videoIds;
@property (strong, nonatomic) NSString * _Nullable actionType;

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate articleCategory:(NSString *_Nullable)articleCategory;

/**
 *  调用请求
 */
- (void)call;

@end
