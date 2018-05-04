//
//  DoPaymentApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const doPaymentUrl = @"/user/api/doPayment";

@interface DoPaymentApi : BaseApi

@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */
@property (copy, nonatomic) NSString * _Nullable money;
@property (copy, nonatomic) NSString * _Nullable type;
@property (copy, nonatomic) NSString * _Nullable account;
@property (copy, nonatomic) NSString * _Nullable realName;

/**
 *  调用请求
 */
- (void)call;

@end
