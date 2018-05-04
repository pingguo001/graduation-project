//
//  NewsCommentCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsCommentCell.h"
#import "NewsCommentModel.h"

@interface NewsCommentCell ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) NewsCommentModel *tempModel;
@property (strong, nonatomic) NSIndexPath *tempIndexPath;

@end

@implementation NewsCommentCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.praiseButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(30));
        make.height.width.mas_equalTo(adaptHeight1334(80));
        
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView.mas_right).offset(adaptWidth750(15));
        make.top.equalTo(self.headImageView).offset(adaptHeight1334(5));
        make.height.mas_equalTo(adaptHeight1334(30));
        
    }];
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.usernameLabel);
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.width.mas_equalTo(adaptWidth750(80));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.usernameLabel);
        make.width.mas_equalTo(kScreenWidth - adaptHeight1334(80) - adaptWidth750(15) * 5);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(adaptHeight1334(15));
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(15));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(20));
        
    }];
}

- (void)configModelData:(NewsCommentModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempModel = model;
    self.tempIndexPath = indexPath;
    self.usernameLabel.text = model.nickname;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.created_at;
    
    if (model.upvote_num.integerValue > 0) {
        [self.praiseButton setTitle:model.upvote_num forState:UIControlStateNormal];
    }
    self.praiseButton.selected = model.is_upvote;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];

}
- (void)buttonAction:(UIButton *)sender
{
    if ([sender isEqual:self.praiseButton]) {
        sender.selected = !sender.selected;
    }
    if (sender.selected) {
        self.tempModel.upvote_num = [NSString stringWithFormat:@"%ld", (self.tempModel.upvote_num.integerValue)+1];
        self.tempModel.is_upvote = YES;
    } else {
        self.tempModel.upvote_num = [NSString stringWithFormat:@"%ld", (self.tempModel.upvote_num.integerValue)-1];
        self.tempModel.is_upvote = NO;
    }
    if (self.tempModel.upvote_num.integerValue > 0) {
        [self.praiseButton setTitle:self.tempModel.upvote_num forState:UIControlStateNormal];
    } else {
        [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    self.praiseButton.selected = self.tempModel.is_upvote;
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        self.headImageView = [UIImageView new];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.layer.cornerRadius = (adaptHeight1334(80))/2.0;
    }
    return _headImageView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR4E6194];
        _usernameLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(28)];
        _usernameLabel.userInteractionEnabled = YES;
    }
    return _usernameLabel;
}

- (UIButton *)praiseButton
{
    if (!_praiseButton) {
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setTitle:@"赞" forState:UIControlStateNormal];
        _praiseButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        [_praiseButton setImage:[UIImage imageNamed:@"headline_list_btn_like"] forState:UIControlStateNormal];
        [_praiseButton setImage:[UIImage imageNamed:@"headline_list_btn_like_pressed"] forState:UIControlStateSelected];
        [_praiseButton setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateNormal];
        [_praiseButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -adaptWidth750(2), 0, 0);
        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(2), 0, 0);
        [_praiseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR060606];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLOR999999];
    }
    return _timeLabel;
}

@end
