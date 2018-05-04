//
//  ShareContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/7.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "ShareContentView.h"
#import "TimelineModel.h"

@interface ShareContentView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) id tempModel;

@end

@implementation ShareContentView

- (void)p_setupViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:backButton];
    [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _backButton = backButton;
    _backButton.userInteractionEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [backButton addSubview:imageView];
    _imageView = imageView;
    _imageView.image = [UIImage imageNamed:@"icon0.jpg"];
    
    UILabel *titleLabel = [UILabel labWithText:@"这是一个音乐" fontSize:adaptFontSize(30) textColorString:COLOR060606];
    titleLabel.numberOfLines = 2;
    [backButton addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIImageView *iconView = [UIImageView new];
    _iconView = iconView;
    [_imageView addSubview:iconView];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self);
        
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(adaptHeight1334(150));
        
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(imageView);
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView.mas_right).offset(adaptWidth750(20));
        make.top.bottom.equalTo(imageView);
        make.right.equalTo(self).offset(-adaptWidth750(20));
        
    }];
}

- (void)configDataModel:(TimelineModel *)model
{
    if ([model.cover containsString:@"?"]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover componentsSeparatedByString:@"?"].firstObject]];
    } else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover componentsSeparatedByString:@","].firstObject]];
    }
    _titleLabel.text = model.title;
}


- (void)buttonAction:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareContentActionWithModel:)]) {
        [self.delegate shareContentActionWithModel:_tempModel];
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
