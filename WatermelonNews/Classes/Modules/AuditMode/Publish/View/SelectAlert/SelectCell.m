//
//  SelectCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/1.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "SelectCell.h"

@interface SelectCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView  *lineView;

@end

@implementation SelectCell

- (void)p_setupViews
{
    UILabel *titleLabel = [UILabel labWithText:@"测试" fontSize:adaptFontSize(32) textColorString:COLOR060606];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    _lineView = lineView;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(adaptHeight1334(1));
        
    }];
}

/**
 更新数据源

 @param model 模型
 @param indexPath 位置
 */
- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = model;
    if (indexPath.row == 1 || indexPath.section == 1 ) {
        _lineView.hidden = YES;
    } else {
        
        _lineView.hidden = NO;
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
