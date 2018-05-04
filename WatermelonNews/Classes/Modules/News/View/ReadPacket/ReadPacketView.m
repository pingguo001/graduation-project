//
//  ReadPacketView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ReadPacketView.h"
#import "UIImage+GIF.h"

@interface ReadPacketView ()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation ReadPacketView

- (void)p_setupViews
{
//    self.frame = [UIScreen mainScreen].bounds;
//    UIColor * color = [UIColor blackColor];
//    self.backgroundColor = [color colorWithAlphaComponent:0.8];
    
    self.backImageView = [UIImageView new];
    self.backImageView.center = [UIApplication sharedApplication].keyWindow.center;
    self.backImageView.width = adaptWidth750(320);
    self.backImageView.height = adaptHeight1334(420);
    self.backImageView.image = [UIImage imageNamed:@"bghong"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backImageView];
    

    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage sd_animatedGIFNamed:@"star"];
    
    [self.backImageView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel labWithText:@"阅读红包" fontSize:adaptFontSize(36) textColorString:COLORFFFFFF];
    titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(34)];
    [self.backImageView addSubview:titleLabel];
    
    UILabel *moneyLabel = [UILabel labWithText:@"+0.47元" fontSize:adaptFontSize(92) textColorString:COLORF7FB06];
    [self.backImageView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
//    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.center.equalTo([UIApplication sharedApplication].keyWindow);
//        make.height.mas_equalTo(adaptHeight1334(420));
//        make.width.mas_equalTo(adaptWidth750(320));
//        
//    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backImageView).offset(-adaptWidth750(17));
        make.top.equalTo(self.backImageView).offset(adaptHeight1334(200));
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.backImageView).offset(adaptHeight1334(166));
        
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(titleLabel.mas_bottom).offset(adaptHeight1334(20));

    }];
    
}


- (void)showPacketViewMoney:(NSString *)moneyStr offSet:(NSInteger)offSet
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        
        if ([view isKindOfClass:[self.backImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _moneyLabel.text = [NSString stringWithFormat:@"+%@元", moneyStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_moneyLabel.text];
    
    //设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:adaptFontSize(34)] range:NSMakeRange(_moneyLabel.text.length-1, 1)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backImageView];

    _moneyLabel.attributedText = attrStr;
    self.backImageView.layer.position = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y + offSet);
    self.backImageView.transform = CGAffineTransformMakeScale(0.20, 0.20);
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.backImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
    
}

- (void)dismiss
{
    self.backImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.2 delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.backImageView.transform = CGAffineTransformMakeScale(0.000001, 0.0000001);
                         
                     } completion:^(BOOL finished) {
                         [self.backImageView removeFromSuperview];
                     }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
