//
//  ShowCommentView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShowCommentView.h"

@interface ShowCommentView ()

@property (strong, nonatomic) UIButton *publishButton;

@end

@implementation ShowCommentView

- (void)p_setupViews
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:lineView];
    
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
    
    UIView *holdView = [UIView new];
    holdView.layer.cornerRadius = 18;
    holdView.layer.masksToBounds = YES;
    holdView.backgroundColor = [UIColor colorWithString:COLORF4F6F6];
    holdView.layer.borderColor = [UIColor colorWithString:COLORE8E8E8].CGColor;
    holdView.layer.borderWidth = 0.5;
    [self addSubview:holdView];
    
    HPGrowingTextView *commentTextView = [HPGrowingTextView new];
    [holdView addSubview:commentTextView];
    _commentTextView = commentTextView;
    _commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.textColor = [UIColor colorWithString:COLOR060606];
    commentTextView.textAlignment = NSTextAlignmentLeft;
    commentTextView.font = [UIFont systemFontOfSize:16];
    commentTextView.delegate = self;
    commentTextView.minNumberOfLines = 1;
    commentTextView.maxNumberOfLines = 3;
    commentTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    commentTextView.placeholder = @"优质评论将会被优先展示";
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [self addSubview:publishButton];
    _publishButton = publishButton;
    publishButton.userInteractionEnabled = NO;
    [publishButton setTitleColor:[UIColor colorWithString:COLORA9A9A9] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-7);
        make.right.equalTo(publishButton.mas_left).offset(-adaptWidth750(36));
        
    }];
    
    [commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(holdView).offset(adaptWidth750(20));
        make.top.bottom.equalTo(holdView);
        make.right.equalTo(holdView).offset(-adaptWidth750(10));
        
    }];
    
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-adaptWidth750(30));
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

    
}

- (void)publishAction:(UIButton *)sender
{
    if (self.backResult) {
        self.backResult(0);
    }
}

- (void)showCommentView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.commentTextView becomeFirstResponder];
}

- (void)dimiss
{
    [self.commentTextView resignFirstResponder];

}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize键盘尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    WNLog(@"hight_hitht:%f",kbSize.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = kScreenHeight - kbSize.height - _commentTextView.height - 14;
    }];
}

- (void)keyboardWillHide
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = kScreenHeight;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.frame = r;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length == 0) {
        
        _publishButton.userInteractionEnabled = NO;
        [_publishButton setTitleColor:[UIColor colorWithString:COLORA9A9A9] forState:UIControlStateNormal];
    } else {
        
        
        _publishButton.userInteractionEnabled = YES;
        [_publishButton setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
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
