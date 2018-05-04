//
//  FeedbackView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "FeedbackView.h"

@interface FeedbackView ()<UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeHolder;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UILabel *stringLenghLabel;
@property (strong, nonatomic) UILabel *explainLabel;

@end

@implementation FeedbackView

- (void)p_setupViews
{
    self.backgroundColor = [UIColor colorWithString:COLORF5F5F5];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    self.feedbackTextView = [UITextView new];
    self.feedbackTextView.backgroundColor = [UIColor colorWithString:COLORF8F8F8];
    self.feedbackTextView.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    self.feedbackTextView.delegate = self;
    [headerView addSubview:self.feedbackTextView];
    
    self.placeHolder = [UILabel labWithText:@"请详细描述您的问题..." fontSize:adaptFontSize(30) textColorString:COLORC0C0C0];
    self.placeHolder.userInteractionEnabled = NO;
    [self.feedbackTextView addSubview:self.placeHolder];
    
    self.stringLenghLabel = [UILabel labWithText:@"0/50" fontSize:adaptFontSize(26) textColorString:COLORC0C0C0];
    [self.feedbackTextView addSubview:self.stringLenghLabel];
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footerView];
    
    self.contactTextField = [UITextField new];
    self.contactTextField.placeholder = @"QQ，邮件或者电话";
    self.contactTextField.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.contactTextField.layer.borderWidth = 0.5;
    self.contactTextField.layer.borderColor = [UIColor colorWithString:COLORCACACA].CGColor;
    self.contactTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(20), adaptHeight1334(80))];
    self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
    [footerView addSubview:self.contactTextField];
    
    self.explainLabel = [UILabel labWithText:@"您的联系方式有助于我们沟通和解决问题，仅工作人员可见" fontSize:adaptFontSize(26) textColorString:COLORC0C0C0];
    [footerView addSubview:self.explainLabel];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.backgroundColor = [UIColor colorWithString:COLORCCCCCC];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    self.commitButton.userInteractionEnabled = NO;
    [self addSubview:self.commitButton];
    self.commitButton.layer.cornerRadius = adaptHeight1334(8);
    self.commitButton.layer.masksToBounds = YES;
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(64);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(272));
        
    }];
    
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(headerView).offset(adaptWidth750(30));
        make.right.bottom.equalTo(headerView).offset(-adaptWidth750(30));
        
    }];
    
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.feedbackTextView).offset(adaptWidth750(14));
        
    }];
    
    [self.stringLenghLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.feedbackTextView).offset(kScreenWidth - adaptWidth750(140));
        make.top.equalTo(self.feedbackTextView).offset(adaptHeight1334(170));
        
    }];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(headerView.mas_bottom).offset(adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(170));
        
    }];
    
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(footerView).offset(adaptWidth750(30));
        make.right.equalTo(footerView).offset(-adaptWidth750(30));
        make.height.mas_equalTo(adaptHeight1334(80));
        
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contactTextField);
        make.top.equalTo(self.contactTextField.mas_bottom).offset(adaptHeight1334(10));
        
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView.mas_bottom).offset(adaptHeight1334(100));
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.height.mas_equalTo(adaptHeight1334(84));
        
    }];
    
    
}

//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    WNLog(@"%@", textView.text);
    
    self.placeHolder.hidden = YES;
    if (self.contactTextField.text.length != 0) {
        //允许提交按钮点击操作
        self.commitButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
        self.commitButton.userInteractionEnabled = YES;
    }
    
    self.stringLenghLabel.textColor = [UIColor colorWithString:COLOR39AF34];
    //实时显示字数
    self.stringLenghLabel.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 50) {
        
        textView.text = [textView.text substringToIndex:50];
        self.stringLenghLabel.text = @"50/50";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeHolder.hidden = NO;
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithString:COLORCCCCCC];
        self.stringLenghLabel.textColor = [UIColor colorWithString:COLORCCCCCC];

        
    }
    
}

- (void)textFieldDidChange
{
    if (self.feedbackTextView.text.length != 0) {
        
        //允许提交按钮点击操作
        self.commitButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
        self.commitButton.userInteractionEnabled = YES;
    }
    
    if (self.contactTextField.text.length == 0) {
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithString:COLORCCCCCC];
    }
}

- (void)commitAction
{
    [self endEditing:YES];
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
