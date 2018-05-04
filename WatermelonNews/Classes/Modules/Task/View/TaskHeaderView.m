//
//  TaskHeaderView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskHeaderView.h"

@interface TaskHeaderView ()

@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) UIImageView *detailImageView;

@end

@implementation TaskHeaderView

- (void)p_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *placeView = [UIView new];
    UIColor * color = [UIColor colorWithString:COLOR39AF34];
    placeView.backgroundColor = [color colorWithAlphaComponent:0.1];
    [self addSubview:placeView];
    
    _balanceLabel = [UILabel labWithText:@"我的余额(元) ￥****" fontSize:adaptFontSize(40) textColorString:COLOR39AF34];
    [self setBalanceData:_balanceLabel.text];
    [placeView addSubview:_balanceLabel];
    
    _detailImageView = [UIImageView new];
    _detailImageView.image = [UIImage imageNamed:@"combined_shape"];
    [placeView addSubview:_detailImageView];
    
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo(self);
    }];
    
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(adaptWidth750(44));
        make.centerY.equalTo(placeView);
        
    }];
    
    [_detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(placeView).offset(-adaptWidth750(kSpecWidth));
        make.centerY.equalTo(placeView);

    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
}

- (void)configModelData:(MoneyInfoModel *)model
{
    _balanceLabel.text = [NSString stringWithFormat:@"我的余额(元) ￥%.2f",model.remainingMoney.floatValue];
    [self setBalanceData:_balanceLabel.text];
}

//富文本
- (void)setBalanceData:(NSString *)str
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:adaptFontSize(32)]} range:[str rangeOfString:@"我的余额(元)"]];
    _balanceLabel.attributedText = attributeString;
}

- (void)tapAction
{
    if (self.backResult) {
        
        self.backResult(0);
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
