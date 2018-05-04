//
//  VideoTitleView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "VideoTitleView.h"
#import "NewsArticleModel.h"

@interface VideoTitleView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation VideoTitleView

- (void)p_setupViews
{
    //标题
    self.titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(36) textColorString:COLOR060606];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(36)];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    //说明
    self.detailLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLORA9A9A9];
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(24)];
    [self addSubview:self.detailLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(30) * 2);
        make.top.equalTo(self).offset(adaptHeight1334(25));
        
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(15));
        
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:lineView];
    lineView.hidden = YES;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
}

- (void)confignData:(NewsArticleModel *)model
{
    self.titleLabel.text = model.title;
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
    self.height = [self getLabelHeightWithText:self.titleLabel.text width:kScreenWidth - adaptWidth750(30) * 2 font:adaptFontSize(36)] + adaptHeight1334(110);
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
