//
//  InviteHelpCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InviteHelpCell.h"

@interface InviteHelpCell ()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIButton *sureButton;

@end

@implementation InviteHelpCell

- (void)p_setupViews
{
    self.backImageView = [UIImageView new];
    [self.contentView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.contentView);
        
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.sureButton];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"invitation_btn_start"] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(140));
        
    }];
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    self.backImageView.image = [UIImage imageNamed:model];
    if (indexPath.row == 3) {
        self.sureButton.hidden = NO;
    } else {
        self.sureButton.hidden = YES;
    }
}

- (void)sureAction
{
    if (self.inviteAction) {
        self.inviteAction();
    }
}

@end
