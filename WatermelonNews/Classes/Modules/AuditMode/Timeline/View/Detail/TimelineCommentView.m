//
//  BottomCommentView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TimelineCommentView.h"

@interface TimelineCommentView ()


@end

@implementation TimelineCommentView

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
    commentButton.tag = 500;

    
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [praiseButton setBackgroundImage:[UIImage imageNamed:@"detail_btn_list_like"] forState:UIControlStateNormal];
    [praiseButton setBackgroundImage:[UIImage imageNamed:@"detail_btn_list_like_pressed"] forState:UIControlStateSelected];
    [self addSubview:praiseButton];
    praiseButton.tag = 501;
    self.praiseButton = praiseButton;
    
    [commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [praiseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-7);
        make.right.equalTo(praiseButton.mas_left).offset(-adaptWidth750(38));
        
    }];
    
    [praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-adaptWidth750(30*2));
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 500) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCommentViewIndex:)]) {
            [self.delegate didClickCommentViewIndex:sender.tag - 500];
        }
    } else {
        
        sender.selected = !sender.selected;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCommentViewIndex:)]) {
            if (sender.selected) {
                [self.delegate didClickCommentViewIndex:1];
            } else {
                [self.delegate didClickCommentViewIndex:2];
            }
        }
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
