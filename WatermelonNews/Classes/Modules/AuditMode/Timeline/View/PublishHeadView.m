//
//  PublishHeadView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "PublishHeadView.h"

@implementation PublishHeadView

- (void)p_setupViews
{
    NSArray *titleArray = @[@"发文字", @"发图片"].mutableCopy;
    NSArray *iconArray = @[@"headline_btn_write", @"headline_btn_pic"].mutableCopy;
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -adaptWidth750(15), 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(15), 0, 0);
        button.tag = 200+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(i * (kScreenWidth / 2.0));
            make.top.equalTo(self);
            make.height.mas_equalTo(kViewHeight);
            make.width.mas_equalTo(kScreenWidth/2.0);
            
        }];
    }
    
    UIView *specView = [UIView new];
    specView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:specView];
    
    [specView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.height.mas_equalTo(self.height/2.0);
        make.width.mas_equalTo(0.5);
        
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-adaptHeight1334(10));
        make.height.mas_equalTo(0.5);
        
    }];

}

- (void)buttonAction:(UIButton *)sender
{
    if (self.backResult) {
        self.backResult(sender.tag - 200);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
