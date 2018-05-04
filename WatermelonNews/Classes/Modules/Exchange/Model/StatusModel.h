//
//  StatusModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusModel : NSObject

@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *checkMoney;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *flag;
@property (copy, nonatomic) NSString *hasWeixinPay;
@property (copy, nonatomic) NSString *is_read;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *type;

@end
