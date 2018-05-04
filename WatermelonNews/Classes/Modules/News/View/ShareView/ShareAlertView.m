//
//  ShareAlertView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShareAlertView.h"

@interface ShareAlertView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *shareBackView;
@property (weak, nonatomic) id<ShareAlertViewDelegate>delegate;

@end

@implementation ShareAlertView

- (void)p_setupViews
{
    self.frame = [UIScreen mainScreen].bounds;
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *shareBackView = [UIView new];
    shareBackView.backgroundColor = [UIColor colorWithString:COLORF8F8F8];
    _shareBackView = shareBackView;
    _shareBackView.userInteractionEnabled = YES;
    [self addSubview:shareBackView];
    shareBackView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, adaptHeight1334(400));
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBackView addSubview:cancleButton];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [cancleButton setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithString:COLORB5B5B5] forState:UIControlStateHighlighted];
    CGSize size = CGSizeMake(kScreenWidth, adaptHeight1334(98));
    [cancleButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:size] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORECECEB] size:size] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [UILabel labWithText:@"分享到" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_shareBackView addSubview:titleLabel];
    
    NSMutableArray *iconArray = @[@"newspage_shareit_weixin", @"newspage_shareit_friends", @"newspage_shareit_space", @"newspage_shareit_qq"].mutableCopy;
    NSMutableArray *titleArray = @[ @"微信", @"朋友圈", @"QQ空间", @"QQ"].mutableCopy;
    
    if ([UserManager currentUser].applicationMode.integerValue == 1) {
        
        iconArray[3] = @"newspage_shareit_report";
        titleArray[3] = @"投诉";
        
        iconArray[2] = @"share_btn_headline";
        titleArray[2] = @"转发到圈子";
    }
    
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_shareBackView).offset(idx * kScreenWidth / 4);
            make.top.equalTo(titleLabel.mas_bottom).offset(adaptHeight1334(20));
            make.bottom.equalTo(cancleButton.mas_top);
            make.width.mas_equalTo(kScreenWidth / 4);
            
        }];
        
        UIButton *iconImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        iconImageButton.tag = 500 + idx;
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [button addSubview:iconImageButton];
        
        UILabel *titleLabel = [UILabel labWithText:titleArray[idx] fontSize:adaptFontSize(26) textColorString:COLOR060606];
        [button addSubview:titleLabel];
        
        [iconImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(button);
            make.top.equalTo(button).offset(adaptHeight1334(40));
            
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(iconImageButton);
            make.top.equalTo(iconImageButton.mas_bottom).offset(adaptHeight1334(15));
            
        }];
        
    }];
    

    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_shareBackView);
        make.top.equalTo(_shareBackView).offset(adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(44));
        
    }];
    
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(_shareBackView);
        make.height.mas_equalTo(adaptHeight1334(98));
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectShareIndex:)]) {
        
        [self.delegate didSelectShareIndex:sender.tag - 500];
        [self dismiss];
    }
}

- (void)showShareViewDelegate:(id<ShareAlertViewDelegate>)delegate
{
    self.delegate = delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shareBackView.y = kScreenHeight - self.shareBackView.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.shareBackView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isEqual:_shareBackView]) {
        return NO;
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
