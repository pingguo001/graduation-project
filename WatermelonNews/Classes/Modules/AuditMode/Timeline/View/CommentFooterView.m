//
//  CommentFooterView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CommentFooterView.h"
#import "TimelineModel.h"

@interface CommentFooterView()

@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *praiseButton;

@end

@implementation CommentFooterView

- (void)p_setupViews
{
    NSArray *titleArray = @[@"", @""].mutableCopy;
    NSArray *iconArray = @[@"headline_list_btn_like", @"headline_list_btn_talk"].mutableCopy;
    NSArray *selectArray = @[@"headline_list_btn_like_pressed", @"headline_list_btn_talk"].mutableCopy;
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectArray[i]] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -adaptWidth750(15), 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(15), 0, 0);
        [button setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.praiseButton = button;
        } else {
            self.commentButton = button;
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(i * (kScreenWidth / 2.0));
            make.top.equalTo(self);
            make.height.equalTo(self);
            make.width.mas_equalTo(kScreenWidth/2.0);
            
        }];
    }
    
    self.commentButton.userInteractionEnabled = NO;
}

- (void)buttonAction:(UIButton *)sender
{
    if ([sender isEqual:self.praiseButton]) {
        sender.selected = !sender.selected;
    }
    if (self.backResult) {
        self.backResult(sender.selected);
    }
}

- (void)configData:(TimelineModel *)model
{
    if (model.comment_num.integerValue > 0) {
        [self.commentButton setTitle:model.comment_num forState:UIControlStateNormal];
    } else {
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
//    if (model.is_myself) {
//        model.praise_num = @"0";
//    }
    if (model.praise_num.integerValue > 0) {
        [self.praiseButton setTitle:model.praise_num forState:UIControlStateNormal];
    } else {
        [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    self.praiseButton.selected = model.is_praise;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
