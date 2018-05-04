//
//  ShowDataView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShowDataView.h"

@interface ShowDataView ()

@property (strong, nonatomic) UILabel *placeLabel;

@end

@implementation ShowDataView

- (void)p_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *placeView = [UIView new];
    UIColor * color = [UIColor colorWithString:COLOR39AF34];
    placeView.backgroundColor = [color colorWithAlphaComponent:0.1];
    [self addSubview:placeView];
    
    UILabel *placeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR39AF34];
    placeLabel.textAlignment = NSTextAlignmentCenter;
    [placeView addSubview:placeLabel];
    _placeLabel = placeLabel;
    
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo(self);

    }];
    
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.top.left.bottom.equalTo(placeView);
        
    }];
    
}

- (void)setDataNumber:(NSInteger)number
{
    if (number == 0) {
        
        _placeLabel.text = [NSString stringWithFormat:@"没有更新的内容"];

    } else {
        _placeLabel.text = [NSString stringWithFormat:@"西瓜头条成功为您推荐%ld条新内容", (long)number];
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
