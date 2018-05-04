//
//  ShootView.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShootView.h"

@interface ShootView ()

@property (strong, nonatomic) UIButton *sureButton;    //完成
@property (strong, nonatomic) UIButton *cancleButton;  //取消
@property (strong, nonatomic) UIView   *leftplace;     //左占位
@property (strong, nonatomic) UIView   *rightplace;    //右占位
@property (strong, nonatomic) UIButton *closeButton;   //关闭
@property (strong, nonatomic) UIButton *shootButton;   //拍照
@property (strong, nonatomic) UIImageView *focusView;  //对焦框

@end

@implementation ShootView

- (void)p_setupViews
{
    self.backgroundColor = [UIColor clearColor];
    //拍照
    UIButton *shootButton = [self createButtonWithImageNormal:@"photograph" Highlighted:nil];
    [self addSubview:shootButton];
    _shootButton = shootButton;
    
    //左占位
    UIView *leftplace = [UIView new];
    leftplace.backgroundColor = [UIColor clearColor];
    [self addSubview:leftplace];
    _leftplace = leftplace;
    
    //关闭
    UIButton *closeButton = [self createButtonWithImageNormal:@"photograph_return" Highlighted:nil];
    [self addSubview:closeButton];
    _closeButton = closeButton;
    
    //完成
    UIButton *sureButton = [self createButtonWithImageNormal:@"comera_comfirm" Highlighted:@"comera_comfirm"];
    sureButton.hidden = YES;
    [self addSubview:sureButton];
    _sureButton = sureButton;
    
    //取消
    UIButton *cancleButton = [self createButtonWithImageNormal:@"comera_return" Highlighted:nil];
    cancleButton.hidden = YES;
    [self addSubview:cancleButton];
    _cancleButton = cancleButton;
    
    //右占位
    UIView *rightplace = [UIView new];
    rightplace.backgroundColor = [UIColor clearColor];
    [self addSubview:rightplace];
    _rightplace = rightplace;
    
    _focusView = [[UIImageView alloc] init];
    _focusView.image = [UIImage imageNamed:@"bg_focusing"];
    _focusView.frame = CGRectMake(0, 0, _focusView.image.size.width, _focusView.image.size.height);
    [self addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusingGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    //layout
    [shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-adaptHeight1334(96));
    }];
    
    [leftplace mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(shootButton.mas_left);
        
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(shootButton);
        make.centerX.equalTo(leftplace);
        make.width.height.equalTo(shootButton);
        
    }];
    
    [rightplace mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.left.equalTo(shootButton.mas_right);
        
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shootButton);
    }];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shootButton);
    }];
}

#pragma mark - public methond

//拍照完成
- (void)shootComplete
{
    //拍照完成后 拍照按钮消失，取消和完成按钮动画展出
    _shootButton.hidden = YES;
    _cancleButton.hidden = NO;
    _sureButton.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _cancleButton.centerX = _leftplace.centerX;
        _sureButton.centerX = _rightplace.centerX;
        
    }];
}

#pragma mark - private methond

/**
 事件action
 
 @param sender button点击
 */
- (void)buttonAction:(UIButton *)sender
{
    if ([sender isEqual:_shootButton]) {
        //隐藏关闭按钮
        _closeButton.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(shootAction)]) {
            [self.delegate shootAction];
        }
    } else if ([sender isEqual:_closeButton]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeAction)]) {
            [self.delegate closeAction];
        }
        
    } else if ([sender isEqual:_cancleButton]) {
        
        [self cancleReshoot];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancleAction)]) {
            [self.delegate cancleAction];
        }
        
    } else if ([sender isEqual:_sureButton]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sureAction)]) {
            [self.delegate sureAction];
        }
    }
    
}

//取消重拍
- (void)cancleReshoot
{
    [UIView animateWithDuration:0.05 animations:^{
        
        _cancleButton.centerX = _shootButton.centerX;
        _sureButton.centerX = _shootButton.centerX;
        
    } completion:^(BOOL finished) {
        
        _cancleButton.hidden = YES;
        _sureButton.hidden = YES;
        _shootButton.hidden = NO;
        _closeButton.hidden = NO;
        
    }];
}

- (void)focusingGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusingAnimationAtPoint:point];
}

//对焦图层动画
- (void)focusingAnimationAtPoint:(CGPoint)point
{
    _focusView.center = point;
    _focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _focusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _focusView.hidden = YES;
        }];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusingActionAtPoint:)]) {
        [self.delegate focusingActionAtPoint:point];
    }
}

/**
 创建button

 @param normal 正常图片
 @param highlighted 高亮图片
 @return 自定义button
 */
- (UIButton *)createButtonWithImageNormal:(NSString *)normal Highlighted:(NSString *)highlighted
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlighted != nil ? highlighted : normal] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
