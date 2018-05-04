//
//  ExchangeCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/28.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeCell.h"

@interface ExchangeCell ()

@end

@implementation ExchangeCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:_titleLabel];
    
    _moneyLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(34) textColorString:COLOR39AF34];
    [self.contentView addSubview:_moneyLabel];
    _moneyLabel.textColor = [UIColor redColor];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        
    }];
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    
}

@end
