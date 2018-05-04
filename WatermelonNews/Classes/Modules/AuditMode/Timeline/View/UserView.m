//
//  UserView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UserView.h"
#import "UserModel.h"
#import "TimelineModel.h"
#import "PersonalViewController.h"

@interface UserView ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *reportButton;

@end

@implementation UserView

- (void)p_setupViews
{
    [self addSubview:self.headImageView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.reportButton];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.headImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.usernameLabel addGestureRecognizer:tap2];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(adaptHeight1334(80));
        
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView.mas_right).offset(adaptWidth750(15));
        make.top.equalTo(self.headImageView).offset(adaptHeight1334(5));
        
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.usernameLabel);
        make.right.equalTo(self).offset(-adaptWidth750(30));
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.usernameLabel);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(adaptHeight1334(10));
        
    }];
    
}

- (void)tapAction
{
    if (self.backResult) {
        self.backResult(0);
    }
}

- (void)buttonAction
{
    if (self.backResult) {
        self.backResult(1);
    }
}

- (void)configData:(TimelineModel *)model
{
    if (model.channel == nil || model.channel.length == 0) {
        
        self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];
        
    } else {
        
        if ([model.channel containsString:@"http:"] ||[model.channel containsString:@"https:"] ) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.channel] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];
            
        } else {
            
            self.headImageView.image = [UIImage imageWithContentsOfFile:model.channel];
        }
    }
    self.usernameLabel.text = model.source_detail;
    self.timeLabel.text = model.original_time;
    if ([self.viewController isKindOfClass: [PersonalViewController class]]) {
        self.reportButton.hidden = NO;
        self.reportButton.hidden = model.is_myself;
    } else {
        self.reportButton.hidden = YES;
    }
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        self.headImageView = [UIImageView new];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = (adaptHeight1334(80))/2.0;
        self.headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR060606];
        _usernameLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(28)];
        _usernameLabel.userInteractionEnabled = YES;
    }
    return _usernameLabel;
}

- (UIButton *)reportButton
{
    if (!_reportButton) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setTitle:@"···" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLOR999999];
    }
    return _timeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
