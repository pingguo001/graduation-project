//
//  ExchangeCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/28.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const ExchangeCellID = @"ExchangeCellID";

@interface ExchangeCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end
