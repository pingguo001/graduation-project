//
//  TaskHeaderView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"
#import "MoneyInfoModel.h"

#define kHeaderHeight adaptHeight1334(96)

@interface TaskHeaderView : BaseView

- (void)configModelData:(MoneyInfoModel *)model;

@end
