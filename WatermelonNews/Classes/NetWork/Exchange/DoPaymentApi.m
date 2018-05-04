//
//  DoPaymentApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "DoPaymentApi.h"

@interface DoPaymentApi() <ResponseDelegate, Api>

@end

@implementation DoPaymentApi

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_NEWS stringByAppendingString:doPaymentUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self plainParamsWithQuery:[self queryWithParams:@{@"money":self.money == nil ? @"" : self.money,
                                                              @"type":self.type == nil ? @"" : self.type,
                                                              @"account": self.account == nil ? @"" : self.account,
                                                              @"realName" : self.realName == nil ? @"" : self.realName
                                                              }]];
}

/**
 *  获取请求接口回调
 *
 *  @return 请求回调
 */
- (id<ResponseDelegate> _Nullable)delegate {
    return _delegate;
}

/**
 *  调用请求
 */
- (void)call {
    [self sendWithType:GET priority:PRIORITY_HIGHEST];
}

@end
