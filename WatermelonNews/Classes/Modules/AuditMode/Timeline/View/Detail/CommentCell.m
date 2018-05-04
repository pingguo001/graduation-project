//
//  CommentCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@interface CommentCell ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) CommentModel *tempModel;
@property (strong, nonatomic) NSIndexPath *tempIndexPath;

@end

@implementation CommentCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.praiseButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.headImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.usernameLabel addGestureRecognizer:tap2];
    
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
        make.right.equalTo(self.praiseButton);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(adaptHeight1334(15));
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(15));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(20));
        
    }];
}

- (void)configModelData:(CommentModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempModel = model;
    self.tempIndexPath = indexPath;
    self.usernameLabel.text = model.nickname;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.created_at;
    
    if (model.praise_num.integerValue > 0) {
        [self.praiseButton setTitle:model.praise_num forState:UIControlStateNormal];
    }
    self.praiseButton.selected = model.is_praise;
    
    if (model.avatar == nil || model.avatar.length == 0) {
        
        self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];
        
    } else {
        
        if ([model.avatar containsString:@"http:"] ||[model.avatar containsString:@"https:"] ) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];
            
        } else {
            
            self.headImageView.image = [UIImage imageWithContentsOfFile:model.avatar];
        }
    }
}

- (void)tapAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(personalClickAction:)]) {
        [self.delegate personalClickAction:self.tempIndexPath];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    if ([sender isEqual:self.praiseButton]) {
        sender.selected = !sender.selected;
    }
    if (sender.selected) {
        self.tempModel.praise_num = [NSString stringWithFormat:@"%ld", (self.tempModel.praise_num.integerValue)+1];
        self.tempModel.is_praise = YES;
    } else {
        self.tempModel.praise_num = [NSString stringWithFormat:@"%ld", (self.tempModel.praise_num.integerValue)-1];
        self.tempModel.is_praise = NO;
    }
    if (self.tempModel.praise_num.integerValue > 0) {
        [self.praiseButton setTitle:self.tempModel.praise_num forState:UIControlStateNormal];
    } else {
        [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    self.praiseButton.selected = self.tempModel.is_praise;
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
        _timeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLOR060606];
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
