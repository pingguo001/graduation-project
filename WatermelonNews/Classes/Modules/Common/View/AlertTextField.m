//
//  AlertTextField.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/19.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "AlertTextField.h"

@interface AlertTextField ()<UITextFieldDelegate>

@end

@implementation AlertTextField

- (void)p_setupViews
{
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.borderWidth = adaptWidth750(1);
    textField.layer.borderColor = [UIColor colorWithString:COLORB1BFC8].CGColor;
    textField.font = [UIFont systemFontOfSize:adaptFontSize(32)];
//    textField.layer.cornerRadius = adaptHeight1334(8);
//    textField.layer.masksToBounds = YES;
    textField.backgroundColor = [UIColor colorWithString:COLORF8F8F8];
    textField.placeholder = @"真实姓名";
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(20), adaptHeight1334(100))];
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:textField];
    _textField = textField;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(88));
        
    }];
    
    UILabel *showLabel = [[UILabel alloc] init];
    showLabel.textColor = [UIColor colorWithString:COLORFF5A5D];
    showLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
    showLabel.text = @"支付宝账号";
    showLabel.textAlignment = NSTextAlignmentLeft;
    _showLabel = showLabel;
    [self addSubview:showLabel];
    
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(textField.mas_bottom);
//        make.bottom.equalTo(self);
        
    }];
}


- (void)setLabelHidden:(BOOL)labelHidden
{
    _showLabel.hidden = labelHidden;
    if (labelHidden) {
        
        _textField.layer.borderColor = [UIColor colorWithString:COLORB1BFC8].CGColor;

    } else {
        
        _textField.layer.borderColor = [UIColor colorWithString:COLORFF5A5D].CGColor;

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setLabelHidden:YES];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
