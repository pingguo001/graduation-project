//
//  BottomCommentView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BottomCommentView.h"

@interface BottomCommentView ()

@property (strong, nonatomic) UIButton *numberButton;
@property (strong, nonatomic) UIButton *scrollButton;


@end

@implementation BottomCommentView

- (void)p_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:lineView];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:commentButton];
    commentButton.layer.cornerRadius = 18;
    commentButton.layer.masksToBounds = YES;
    [commentButton setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
    commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentButton setTitle:@"快来写评论吧~" forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"newspage_comment_sofa"] forState:UIControlStateNormal];
    commentButton.backgroundColor = [UIColor colorWithString:COLORF4F6F6];
    commentButton.layer.borderColor = [UIColor colorWithString:COLORE8E8E8].CGColor;
    commentButton.layer.borderWidth = 0.5;
    commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(24), 0, 0);
    commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(34), 0, 0);
    commentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    commentButton.tag = 800;
    
    UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollButton setBackgroundImage:[UIImage imageNamed:@"newspage_comment"] forState:UIControlStateNormal];
    [self addSubview:scrollButton];
    _scrollButton = scrollButton;
    scrollButton.tag = 801;

    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"newspage_shareit"] forState:UIControlStateNormal];
    [self addSubview:shareButton];
    shareButton.tag = 802;

    
    [commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numberButton.backgroundColor = [UIColor colorWithString:COLORE05656];
    [numberButton setTitle:@"0" forState:UIControlStateNormal];
    [scrollButton addSubview:numberButton];
    _numberButton = numberButton;
    numberButton.titleLabel.font = [UIFont systemFontOfSize:9];
    numberButton.layer.cornerRadius = 5;
    numberButton.layer.masksToBounds = YES;
    numberButton.tag = 801;
    [numberButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [numberButton sizeToFit];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-7);
        make.right.equalTo(scrollButton.mas_left).offset(-adaptWidth750(38*2));
        
    }];
    
    [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(scrollButton.mas_right);
        make.centerY.equalTo(scrollButton.mas_top);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(numberButton.titleLabel.mj_textWith + adaptWidth750(15));
        
    }];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-adaptWidth750(30*2));
        
    }];
    
    [scrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareButton);
        make.right.equalTo(shareButton.mas_left).offset(-adaptWidth750(37*2));
        make.width.mas_equalTo([UIImage imageNamed:@"newspage_comment"].size.width);

    }];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCommentViewIndex:)]) {
        [self.delegate didClickCommentViewIndex:sender.tag - 800];
    }
}

- (void)setCommentNumber:(NSString *)number
{
    _numberButton.hidden = [number integerValue] <= 0 ? YES : NO;
    [_numberButton setTitle:number forState:UIControlStateNormal];
    
    [_numberButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_scrollButton.mas_right);
        make.centerY.equalTo(_scrollButton.mas_top);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(_numberButton.titleLabel.mj_textWith + adaptWidth750(15));
        
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
