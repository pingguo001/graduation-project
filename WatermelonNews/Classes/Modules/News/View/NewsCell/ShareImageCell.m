//
//  ShareImageCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/13.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShareImageCell.h"

@interface ShareImageCell ()

@property (strong, nonatomic) UIImageView *shareImageView;

@end

@implementation ShareImageCell

- (void)p_setupViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.shareImageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"xinwenbg"];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.equalTo(self);
        
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        
    }];
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    self.shareImageView.image = [UIImage imageNamed:[UserManager currentUser].inviteReward.integerValue >= 5 ? @"invite_guide_5yuan" : @"invite_guide_2yuan"];
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
