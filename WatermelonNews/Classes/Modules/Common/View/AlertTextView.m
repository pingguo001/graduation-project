//
//  AlertTextView.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/20.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "AlertTextView.h"

@interface AlertTextView ()<UITextViewDelegate>

@end
@implementation AlertTextView

- (void)p_setupViews
{
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderWidth = adaptWidth750(1);
    textView.layer.borderColor = [UIColor colorWithString:COLORB1BFC8].CGColor;
    textView.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    textView.layer.cornerRadius = adaptHeight1334(8);
    textView.layer.masksToBounds = YES;
    textView.userInteractionEnabled = YES;
    textView.delegate = self;

    [self addSubview:textView];
    _textView = textView;
    
    self.placeHolder = [[UILabel alloc] init];
    [textView addSubview:self.placeHolder];
    self.placeHolder.textColor = [UIColor lightGrayColor];
    self.placeHolder.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    self.placeHolder.text = @"用的不爽？说两句";
    
    UILabel *showLabel = [[UILabel alloc] init];
    showLabel.textColor = [UIColor colorWithString:COLOREE5845];
    showLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
    showLabel.text = @"请输入正确的支付宝账号";
    showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel = showLabel;
    [self addSubview:showLabel];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(60 * 4));
        
    }];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(textView).offset(adaptHeight1334(10));
        
    }];
    
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(textView.mas_bottom);
        make.bottom.equalTo(self);
        
    }];
    
    
}

- (void)setLabelHidden:(BOOL)labelHidden
{
    _showLabel.hidden = labelHidden;
    if (labelHidden) {
        
        _textView.layer.borderColor = [UIColor colorWithString:COLORB1BFC8].CGColor;
        
    } else {
        
        _textView.layer.borderColor = [UIColor colorWithString:COLOREE5845].CGColor;
        
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setLabelHidden:YES];
}

//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolder.hidden = YES;
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeHolder.hidden = NO;
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
