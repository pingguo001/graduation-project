//
//  TranspondContentCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TranspondContentCell.h"
#import "ShareContentView.h"
#import "TimelineModel.h"

@interface TranspondContentCell ()<ShareContentViewDelegate>

@property (strong, nonatomic) ShareContentView *shareContentView;

@end

@implementation TranspondContentCell

- (void)p_setupViews
{
    
    [super p_setupViews];
    
    self.shareContentView = [ShareContentView new];
    self.shareContentView.delegate = self;
    [self.contentView addSubview:self.shareContentView];
    
    [self.shareContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(30));
        make.height.mas_equalTo(adaptHeight1334(150));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    
    [self.readLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.shareContentView.mas_bottom).offset(adaptHeight1334(20));
        
    }];

}

- (void)configModelData:(TimelineModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    if (model.transpond == nil || model.transpond.length == 0) {
        self.contentLabel.text = @"转发了";
    } else {
        self.contentLabel.text = model.transpond;
    }
    [self.shareContentView configDataModel:model];
    
}

- (void)shareContentActionWithModel:(id)model
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
