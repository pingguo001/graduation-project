//
//  NewsRelevantCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsRelevantCell.h"

@interface NewsRelevantCell()

@property (strong, nonatomic) UIButton *timeButton;

@end

@implementation NewsRelevantCell

- (void)p_setupViews
{
    [super p_setupViews];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.timeButton];
    [self.timeButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    self.timeButton.userInteractionEnabled = NO;
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
    
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.iconImageView).offset(-adaptWidth750(15));
        make.bottom.equalTo(self.iconImageView).offset(-adaptHeight1334(10));
        make.height.mas_equalTo(adaptHeight1334(40));
        make.width.mas_equalTo(adaptWidth750(90));
    }];
}

- (void)configModelData:(NewsArticleModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image]  placeholderImage:[UIImage imageNamed:@"xinwenbg"]];
    if(model.cover_image != nil){
        model.cover = @[model.cover_image];
    }
    if (model.type.integerValue == 2) {

        [self.timeButton setTitle:model.duration forState:UIControlStateNormal];
        self.timeButton.hidden = NO;
        
        NSString *playStr = [NSString stringWithFormat:@"%ld", model.comment_num.integerValue * 1234];
        NSString *str;
        if (playStr.integerValue < 10000) {
            str = [NSString stringWithFormat:@"%@播放量",playStr];
        } else if (playStr.integerValue > 10000 && playStr.integerValue < 100000){
            str = [NSString stringWithFormat:@"%.1f万播放量",playStr.integerValue / 10000.0];
        } else {
            str = [NSString stringWithFormat:@"%ld万播放量",playStr.integerValue / 100000];
        }
        self.detailLabel.text = [NSString stringWithFormat:@"%@  %@",model.source, str];
        
    } else {
        self.timeButton.hidden = YES;
        self.detailLabel.text = [NSString stringWithFormat:@"%@  %@评论",model.source, model.comment_num];
    }
}

@end
