//
//  ExchangeNotesCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/1.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeNotesCell.h"

@interface ExchangeNotesCell ()

@end

@implementation ExchangeNotesCell

- (void)p_setupViews
{
    self.titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(32) textColorString:COLOR333333];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR666666];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
    
    self.iconImageView = [UIImageView new];
    [self.contentView addSubview:self.iconImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(24));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(20));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(24));
        make.height.mas_equalTo(adaptHeight1334(440));
    }];
    
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
            make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
            make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
            make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(24));
            make.height.mas_equalTo(adaptHeight1334(0));
        }];
    } else {
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
            make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
            make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
            make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(24));
            make.height.mas_equalTo(adaptNormalHeight1334(440));
        }];
    }
}

@end
