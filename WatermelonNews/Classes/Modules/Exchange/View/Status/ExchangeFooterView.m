//
//  ExchangeFooterView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeFooterView.h"
#import "StatusModel.h"

@implementation ExchangeFooterView

- (void)p_setupViews
{
    self.frame = CGRectMake(0, 0, kScreenWidth, adaptHeight1334(270));
    
    UIButton *reprotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reprotButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
    [reprotButton setTitle:@"查看具体原因 并联系客服" forState:UIControlStateNormal];
    [reprotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reprotButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    [self addSubview:reprotButton];
    [reprotButton addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    reprotButton.tag = 300;
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.layer.borderColor = [UIColor colorWithString:COLOR39AF34].CGColor;
    recordButton.layer.borderWidth = 1;
    recordButton.layer.masksToBounds = YES;
    [recordButton setTitle:@"历史提现记录" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    [self addSubview:recordButton];
    [recordButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [reprotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(adaptHeight1334(80));
        make.width.mas_equalTo(adaptWidth750(480));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(40));
        
    }];
    
    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(adaptHeight1334(80));
        make.width.mas_equalTo(adaptWidth750(480));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-adaptHeight1334(40));
        
    }];
}

- (void)configData:(StatusModel *)model
{
    switch (model.flag.integerValue) {
        case 0:{
            self.height = adaptHeight1334(160);
            [[self viewWithTag:300] setHidden:YES];
            break;
        }
        case 1:{
            self.height = adaptHeight1334(270);
            [[self viewWithTag:300] setHidden:NO];
            [[self viewWithTag:300] setTitle:@"嘚瑟一下" forState:UIControlStateNormal];
            break;
        }
        case 2:{
            self.height = adaptHeight1334(270);
            [[self viewWithTag:300] setHidden:NO];
            [[self viewWithTag:300] setTitle:@"查看具体原因 并联系客服" forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)reportAction
{
    if (self.backResult) {
        
        self.backResult(1);
    }
}

- (void)buttonAction
{
    if (self.backResult) {
        
        self.backResult(0);
    }
}

@end
