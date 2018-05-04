//
//  FetchNotificationApi.h
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import "BaseApi.h"

#ifdef DEBUG
#define URL_FETCH_NOTIFICATION @"http://139.129.162.59:8310/v1/user/fetchNotifications"
#else
#define URL_FETCH_NOTIFICATION @"http://sword-api.daodaohelper.cn/v1/user/fetchNotifications"
#endif

@interface FetchNotificationApi : BaseApi
@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)init;

/**
 *  调用请求
 */
- (void)call;

@end
