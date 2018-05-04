//
//  DetailFooterView.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/14.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "DetailFooterView.h"
#import "UICopyButton.h"
#import "TaskDetailModel.h"
#import "CountDownTool.h"
#import "TaskAdManager.h"

@interface DetailFooterView ()

@property (strong, nonatomic) UILabel *countdownLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UICopyButton *myCopyButton;

@end

@implementation DetailFooterView

- (void)p_setupViews
{
    self.frame = CGRectMake(0, 0, kScreenWidth, adaptHeight1334(30+470+60+80+30));
    
    //背景框
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [UIColor colorWithString:COLORDCE3EB].CGColor;
    backView.layer.borderWidth = adaptHeight1334(1);
    [self addSubview:backView];
    
    //任务按钮
    UIButton *taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [taskButton setTitle:@"放弃任务" forState:UIControlStateNormal];
    [taskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [taskButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    taskButton.layer.cornerRadius = adaptHeight1334(10);
    taskButton.layer.masksToBounds = YES;
    taskButton.backgroundColor = [UIColor colorWithString:COLOREE5845];
    taskButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [self addSubview:taskButton];
    
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [backView addSubview:iconImageView];
    _iconImageView = iconImageView;
    iconImageView.layer.cornerRadius = adaptHeight1334(20);
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    iconImageView.layer.masksToBounds = YES;
    
    //copyButton
    UICopyButton *copyButton = [UICopyButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:copyButton];
    _myCopyButton = copyButton;
    [copyButton setTitle:@"****" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(40)];
    [copyButton setTitleColor:[UIColor colorWithString:COLOR1A8DF6] forState:UIControlStateNormal];
    [copyButton setBackgroundImage:[UIImage imageNamed:@"detail_bg_namebox_pressed"] forState:UIControlStateNormal];
    [copyButton setBackgroundImage:[UIImage imageNamed:@"detail_bg_namebox_pressed"] forState:UIControlStateHighlighted];

    copyButton.backResult = ^(NSInteger index) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.backResult) {
                
                self.backResult(2);
            }
        });
        
    };
    
    NSString *textStr = @"复制倒计时：*** 秒";
    UILabel *countdownLabel = [[UILabel alloc] init];
    countdownLabel.textColor = [UIColor colorWithString:COLOREE5845];
    countdownLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [backView addSubview:countdownLabel];
    _countdownLabel = countdownLabel;

    
    //infoLabel
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"按住虚线框2秒，点击拷贝";
    infoLabel.textColor = [UIColor colorWithString:COLOR4E6270];
    infoLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [backView addSubview:infoLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.width.mas_equalTo(adaptWidth750(470));
        make.height.mas_equalTo(adaptHeight1334(470));
        make.top.equalTo(self).offset(adaptHeight1334(30));
        
    }];
    
    [taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backView.mas_bottom).offset(adaptHeight1334(60));
        make.width.equalTo(backView);
        make.centerX.equalTo(backView);
        make.height.mas_equalTo(adaptHeight1334(80));
        
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(adaptHeight1334(60));
        make.width.height.mas_equalTo(adaptHeight1334(140));
        
    }];
    
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.top.equalTo(iconImageView.mas_bottom).offset(adaptHeight1334(30));
        make.width.mas_equalTo(adaptWidth750(308));
        
    }];
    
    [countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.top.equalTo(copyButton.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.top.equalTo(countdownLabel.mas_bottom).offset(adaptHeight1334(10));
        
    }];
    
}

- (void)configModelData:(TaskDetailModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [_myCopyButton setTitle:model.keyword forState:UIControlStateNormal];
    
    _countdownLabel.text = [NSString stringWithFormat:@"%@%@秒",[self stepStrWithModel:model],model.time];
    [CountDownTool timeCountDown:_countdownLabel timeout:model.time.intValue timeoutAction:^(int time) {
        if(time <= 0) {
            if (self.backResult) {
                self.backResult(1);
            }
        } else {
            _countdownLabel.text = [NSString stringWithFormat:@"%@%d秒",[self stepStrWithModel:model],time];
            [self setAttributeStr:_countdownLabel.text];
            model.time = [NSString stringWithFormat:@"%d", time];
        }
    }];
    [self setAttributeStr:_countdownLabel.text];

}

- (void)buttonAction
{
    if (self.backResult) {
        
        self.backResult(0);
    }
}

- (void)setAttributeStr:(NSString *)textStr
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithString:COLOR4E6270]} range:NSMakeRange(0, 6)];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithString:COLOR4E6270]} range:NSMakeRange(textStr.length - 1, 1)];
    _countdownLabel.attributedText = attributeString;
}

- (NSString *)stepStrWithModel:(TaskDetailModel *)model
{
    if ([model.step isEqualToString:@"WAIT_COPY"]) {
        return @"等待复制: ";
    } else if ([model.step isEqualToString:@"WAIT_INSTALL"]) {
        return @"等待下载: ";
    } else if ([model.step isEqualToString:@"WAIT_USE"]) {
        return @"等待体验: ";
    }
    return @"等待复制: ";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
