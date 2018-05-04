//
//  TaskAdCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskAdCell.h"
#import "TaskAdModel.h"
#import "TaskAdManager.h"

static dispatch_source_t _timer;

@interface TaskAdCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *recommendLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *priseImageView;
@property (strong, nonatomic) UILabel *downNumberLabel;
@property (strong, nonatomic) UILabel *integralLabel;

@end

@implementation TaskAdCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = adaptWidth750(15);
    iconImageView.layer.masksToBounds = YES;
    _iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    //keyword
    UILabel *titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(34) textColorString:COLOR060606];
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    //是否推荐
    _recommendLabel = [UILabel labWithText:@"编辑推荐" fontSize:adaptFontSize(20) textColorString:COLORFFFFFF];
    _recommendLabel.backgroundColor = [UIColor colorWithString:COLOR1B87FE];
    _recommendLabel.layer.cornerRadius = adaptWidth750(15);
    _recommendLabel.layer.masksToBounds = YES;
    _recommendLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_recommendLabel];
    
    //subTitle
    _subTitleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(26) textColorString:COLORA9A9A9];
    [self.contentView addSubview:_subTitleLabel];
    
    //星级
    _priseImageView = [UIImageView new];
    _priseImageView.image = [UIImage imageNamed:@"praise_wuxin"];
    [self.contentView addSubview:_priseImageView];
    
    //下载数
    _downNumberLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(26) textColorString:COLOR333333];
    [self.contentView addSubview:_downNumberLabel];
    
    //integral
    UILabel *integralLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(36) textColorString:COLORFFFFFF];
    integralLabel.backgroundColor = [UIColor colorWithString:COLORF35A21];
    integralLabel.layer.cornerRadius = adaptWidth750(8);
    integralLabel.layer.masksToBounds = YES;
    integralLabel.layer.shouldRasterize = YES;
    integralLabel.textAlignment = NSTextAlignmentCenter;
    _integralLabel = integralLabel;
    [self.contentView addSubview:integralLabel];
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.contentView addSubview:lineView];

    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(adaptWidth750(30));
        make.width.height.mas_equalTo(adaptHeight1334(128));
        make.centerY.equalTo(self);
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImageView.mas_right).offset(adaptWidth750(22));
        make.top.equalTo(iconImageView).offset(adaptHeight1334(4));
        
    }];
    
    [_recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel.mas_right).offset(adaptWidth750(10));
        make.centerY.equalTo(titleLabel);
        make.height.mas_offset(adaptHeight1334(30));
        make.width.mas_equalTo(_recommendLabel.mj_textWith + adaptWidth750(20));

        
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(adaptHeight1334(6));
        
    }];
    
    [_priseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(iconImageView).offset(-adaptHeight1334(4));
        
    }];
    
    [_downNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_priseImageView.mas_right).offset(adaptWidth750(14));
        make.top.equalTo(_priseImageView);
        
    }];
    
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(60));
        make.width.mas_equalTo(integralLabel.mj_textWith + adaptWidth750(40));
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        
    }];

}

- (void)configModelData:(TaskAdModel *)model indexPath:(NSIndexPath *)indexPath
{
    [TalkingDataApi trackEvent:TD_SHOW_ICCAD];
    self.titleLabel.text = model.keyword;
    self.subTitleLabel.text = model.sub_title;
    self.downNumberLabel.text = [NSString stringWithFormat:@"%@万人下载", model.download_num];
    if (model.star_num.integerValue == 5) {
        _priseImageView.image = [UIImage imageNamed:@"praise_wuxin"];
    } else {
        _priseImageView.image = [UIImage imageNamed:@"praise_sixin"];
    }
    _recommendLabel.hidden = model.recommend.integerValue == 1 ? NO : YES;
    [self setDownNUmberData:self.downNumberLabel.text];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.integralLabel.text = [NSString stringWithFormat:@"送%.2f元", [model.money floatValue] * [[UserManager currentUser].taskRatio floatValue]];
    [self setIntegralData:self.integralLabel.text];
    WNLog(@"%@", model.tags);
    
    [_integralLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(60));
        make.width.mas_equalTo(_integralLabel.mj_textWith + adaptWidth750(40));
        
    }];
    
}

//money富文本
- (void)setIntegralData:(NSString *)str
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:adaptFontSize(28)]} range:NSMakeRange(0, 1)];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:adaptFontSize(28)]} range:NSMakeRange(str.length - 1, 1)];
    _integralLabel.attributedText = attributeString;
}

- (void)setDownNUmberData:(NSString *)str
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithString:COLORA9A9A9]} range:NSMakeRange(str.length - 3, 3)];
    _downNumberLabel.attributedText = attributeString;
}

@end
