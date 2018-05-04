//
//  SimpleNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "SimpleNewsCell.h"

@interface SimpleNewsCell ()

@end

@implementation SimpleNewsCell

- (void)p_setupViews
{
    [super p_setupViews];
    
    self.iconImageView = [UIImageView new];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.image = [UIImage imageNamed:@"xinwenbg"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.masksToBounds = YES;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.detailLabel);
        make.top.equalTo(self.contentView).offset(adaptHeight1334(30));
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(226) - adaptWidth750(26) * 3);
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-adaptWidth750(32));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(30));
        make.height.mas_equalTo(adaptHeight1334(150));
        make.width.mas_equalTo(adaptWidth750(226));
        
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(34));
        make.right.equalTo(self.titleLabel);
        
    }];
}

- (void)configModelData:(NewsArticleModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover.firstObject]  placeholderImage:[UIImage imageNamed:@"xinwenbg"]];

    [self setContentDidRed:model.isRead];
    [self setContentDidRed:[[ArticleDatabase sharedManager] queryAritcleIsRead:model.articleId]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
