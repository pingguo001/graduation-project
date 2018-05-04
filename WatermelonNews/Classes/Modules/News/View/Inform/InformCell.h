//
//  InformCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const InformCellID = @"InformCellID";

@interface InformCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *iconImageView;

@end
