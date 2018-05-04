//
//  GetPaymentInfoApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const getCheckMoneyUrl = @"/user/api/getCheckMoney";

@interface CheckMoneyApi : BaseApi

@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */

/**
 *  调用请求
 */
- (void)call;

@end