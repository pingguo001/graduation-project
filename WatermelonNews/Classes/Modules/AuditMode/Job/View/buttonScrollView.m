//
//  buttonScrollView.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//
#define KButtonCount 4
#define KButtonWidth kScreenWidth/KButtonCount

#import "buttonScrollView.h"

@implementation buttonScrollView

- (void)setUpView {
    self.contentSize =CGSizeMake(KButtonWidth*self.titleArray.count, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    for(int i =0; i< self.titleArray.count ;i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*KButtonWidth, 0, KButtonWidth, 48);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithString:COLOR333333]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [self addSubview:button];
    }
    
    self.saveButton = (UIButton *)[self viewWithTag:100];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    self.saveButton.selected = YES;
}

- (void)buttonAction: (UIButton *)sender {
    if (self.saveButton != sender) {
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        sender.selected = !sender.selected;
        self.saveButton.selected = !self.saveButton.selected;
        self.saveButton = sender;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:17];
        self.passButton(sender.tag - 100);
        CGFloat offsetX = self.saveButton.center.x - HYScreenW * 0.5;
        if (offsetX < 0) offsetX = 0;
        // 获取最大滚动范围
        CGFloat maxOffsetX = self.contentSize.width - HYScreenW;
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        
        if (self.contentSize.width > [UIScreen mainScreen].bounds.size.width) {
            // 滚动标题滚动条
            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
    }];
}

- (void)buttonClick:(NSInteger)buttonNumber
{
    [self buttonAction:[self viewWithTag:buttonNumber]];
}

@end
