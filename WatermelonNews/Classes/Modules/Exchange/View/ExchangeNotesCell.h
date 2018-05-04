//
//  ExchangeNotesCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/1.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const ExchangeNotesCellID = @"ExchangeNotesCellID";

@interface ExchangeNotesCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *iconImageView;

@end
