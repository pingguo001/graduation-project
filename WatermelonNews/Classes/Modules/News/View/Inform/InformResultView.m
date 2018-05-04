//
//  InformResultView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformResultView.h"

@interface InformResultView ()

@property (strong, nonatomic) UIImageView *resultImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation InformResultView

- (void)p_setupViews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    self.resultImageView = [UIImageView new];
    self.resultImageView.image = [UIImage imageNamed:@"complaint"];
    [self addSubview:self.resultImageView];
    
    self.titleLabel = [UILabel labWithText:@"投诉成功" fontSize:adaptFontSize(38) textColorString:COLOR999999];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    self.contentLabel = [UILabel labWithText:@"感谢您的反馈！我们会认真处理您的投诉。西瓜头条坚决反对任何虚假、犯罪、色情、抄袭的内容，我们会为净化网络环境作出不懈努力！" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text attributes:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(10)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.contentLabel.text.length)];
    [self.contentLabel setAttributedText:attributedString];
    [self.contentLabel sizeToFit];
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
    [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:self.submitButton];
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(80) + 64);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.resultImageView.mas_bottom).offset(adaptHeight1334(40));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(40));
        make.width.mas_equalTo(adaptWidth750(550));
        
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(100));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(49);
        
    }];
    
}

- (void)submitAction
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
