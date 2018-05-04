//
//  VideoShareView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "VideoShareView.h"

@implementation VideoShareView

- (void)p_setupViews
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *backView = [UIView new];
    [self addSubview:backView];
    
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:replayButton];
    [replayButton setTitle:@"重播" forState:UIControlStateNormal];
    [replayButton setImage:[UIImage imageNamed:@"video_replay"] forState:UIControlStateNormal];
    [replayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    replayButton.tag = 600 + 10;
    replayButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    [replayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.bottom.equalTo(replayButton.mas_top);
        make.width.mas_equalTo(adaptWidth750(660));
        make.center.equalTo(self);
        
    }];
    
    [replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.bottom.equalTo(self).offset(-adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(60));
        make.width.mas_equalTo(adaptWidth750(150));
        
    }];
    
    NSArray *iconArray = @[@"video_shareit_weixin", @"video_shareit_friends",@"video_shareit_space", @"video_shareit_qq"];
    NSArray *titleArray = @[@"微信", @"朋友圈", @"QQ空间", @"QQ"];
    
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView).offset(idx * adaptWidth750(660) / 4);
            make.bottom.top.equalTo(backView);
            make.width.mas_equalTo(adaptWidth750(660) / 4);
            
        }];
        
        UIButton *iconImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        iconImageButton.tag = 600 + idx;
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [button addSubview:iconImageButton];
        
        UILabel *titleLabel = [UILabel labWithText:titleArray[idx] fontSize:adaptFontSize(24) textColorString:COLORFFFFFF];
        [button addSubview:titleLabel];
        
        [iconImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(button);
//            make.top.equalTo(button).offset(adaptHeight1334(40));
            
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(iconImageButton);
            make.top.equalTo(iconImageButton.mas_bottom).offset(adaptHeight1334(15));
            
        }];
        
    }];
    
    UILabel *alertLabel = [UILabel labWithText:@"——— 分享到 ———" fontSize:adaptFontSize(28) textColorString:COLORFFFFFF];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-adaptHeight1334(100));
        
        
    }];
    
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.backResult) {
        self.backResult(sender.tag - 600);
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
