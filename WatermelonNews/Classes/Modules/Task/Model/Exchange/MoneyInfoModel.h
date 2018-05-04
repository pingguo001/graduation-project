//
//  MoneyInfoModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyInfoModel : NSObject

@property (copy, nonatomic) NSString *coin;
@property (copy, nonatomic) NSString *downloadMoney;
@property (copy, nonatomic) NSString *inviteCount;
@property (copy, nonatomic) NSString *inviteMoney;
@property (copy, nonatomic) NSString *remainingMoney;
@property (copy, nonatomic) NSString *todayMoney;
@property (copy, nonatomic) NSString *totalMoney;
@property (copy, nonatomic) NSString *yesterdayMoney;

@end
