//
//  CashRecordCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CashRecordCell.h"
#import "RewardHistoryModel.h"

@interface CashRecordCell()

@property (strong, nonatomic) UIImageView *iconImageView; //icon
@property (strong, nonatomic) UILabel *appNameLabel;      //appname
@property (strong, nonatomic) UILabel *integralLabel;     //integral
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIImageView *statusImageView;

@end

@implementation CashRecordCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    _iconImageView.image = [UIImage imageNamed:@"time"];
    [self.contentView addSubview:iconImageView];
    
    //status
    _statusImageView = [UIImageView new];
    _statusImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_statusImageView];
    
    //name
    _appNameLabel = [UILabel labWithText:@"***" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:_appNameLabel];
    
    //integral
    _integralLabel = [UILabel labWithText:@"+0.80元" fontSize:adaptFontSize(34) textColorString:COLOR39AF34];
    _integralLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_integralLabel];
    
    //收入时间
    _dateLabel = [UILabel labWithText:@"2017-6-13 19:59:59" fontSize:adaptFontSize(26) textColorString:COLOR77858E];
    [self.contentView addSubview:_dateLabel];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));

    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.dateLabel);
        make.left.equalTo(self.appNameLabel);
        
    }];
    
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(adaptHeight1334(kSpecWidth));
        make.left.equalTo(_statusImageView.mas_right).offset(adaptWidth750(10));
    }];
    
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_iconImageView.mas_right).offset(adaptWidth750(10));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(30));
        
    }];
    
}

- (void)configModelData:(RewardHistoryModel *)model indexPath:(NSIndexPath *)indexPath
{
    _appNameLabel.text = model.content;
    _integralLabel.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
    _dateLabel.text = model.date;
    if (model.status.integerValue == 1) {
        _statusImageView.image = [UIImage imageNamed:@"record_suc"];
    } else if (model.status.integerValue == 2){
        _statusImageView.image = [UIImage imageNamed:@"record_fail"];
    } else {
        _statusImageView.image = [UIImage imageNamed:@""];
    }
}

@end
