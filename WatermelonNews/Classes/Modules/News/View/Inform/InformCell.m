//
//  InformCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformCell.h"

@implementation InformCell

- (void)p_setupViews
{
    self.titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR999999];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.image = [UIImage imageNamed:@"reasons"];
    [self.contentView addSubview:self.iconImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-adaptWidth750(40));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
