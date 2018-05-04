//
//  FreshNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "FreshNewsCell.h"

@implementation FreshNewsCell

- (void)p_setupViews
{
    UILabel *titleLabel = [UILabel labWithText:@"上次您看到这里  点击刷新" fontSize:adaptFontSize(28) textColorString:COLOR39AF34];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"newspage_refresh"];
    [self.contentView addSubview:iconImageView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.contentView addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(-adaptWidth750(20));
        
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(titleLabel.mas_right).offset(adaptWidth750(15));
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
