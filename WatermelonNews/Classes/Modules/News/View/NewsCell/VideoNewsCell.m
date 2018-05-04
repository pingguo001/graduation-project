//
//  VideoNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "VideoNewsCell.h"

#define kImageHeight adaptNormalHeight1334(410)


@interface VideoNewsCell ()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *timeButton;

@end

@implementation VideoNewsCell

- (void)p_setupViews
{
    [super p_setupViews];
    
    self.backImageView = [UIImageView new];
    [self.contentView addSubview:self.backImageView];
    self.backImageView.image = [UIImage imageNamed:@"xinwenbg"];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds = YES;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.playButton];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    self.playButton.userInteractionEnabled = NO;
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.timeButton];
    [self.timeButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    self.timeButton.userInteractionEnabled = NO;
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(adaptWidth750(25));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(26) * 2);

    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(25));
        make.height.mas_equalTo(kImageHeight);
        
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backImageView);
    }];
    
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backImageView).offset(-adaptWidth750(15));
        make.bottom.equalTo(self.backImageView).offset(-adaptHeight1334(10));
        make.height.mas_equalTo(adaptHeight1334(40));
        make.width.mas_equalTo(adaptWidth750(90));
        
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backImageView.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(34));
        make.right.equalTo(self.titleLabel);
        
    }];
    
}

- (void)configModelData:(NewsArticleModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover.firstObject]  placeholderImage:[UIImage imageNamed:@"xinwenbg"]];
    [self setContentDidRed:model.isRead];
    [self setContentDidRed:[[ArticleDatabase sharedManager] queryAritcleIsRead:model.articleId]];
    [self.timeButton setTitle:model.duration forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
