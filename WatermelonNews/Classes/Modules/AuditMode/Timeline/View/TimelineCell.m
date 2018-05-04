//
//  TimelineCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TimelineCell.h"
#import "TimelineModel.h"
#import "TimelineDetailViewController.h"

@interface TimelineCell ()

@property (strong, nonatomic) NSIndexPath *tempIndexPath;
@property (strong, nonatomic) TimelineModel *tempModel;

@end

@implementation TimelineCell

- (void)p_setupViews
{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.userInfoView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.readLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.commentView];
    
    @kWeakObj(self)
    self.userInfoView.backResult = ^(NSInteger index) {
        if (index == 0) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(personalClickAction:)]) {
                [selfWeak.delegate personalClickAction:selfWeak.tempIndexPath];
            }
        } else {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(reportAction)]) {
                [selfWeak.delegate reportAction];
            }
        }
        
    };
    
    self.commentView.backResult = ^(NSInteger index) {
        
        if (index == 1) {
            selfWeak.tempModel.praise_num = [NSString stringWithFormat:@"%ld", (selfWeak.tempModel.praise_num.integerValue)+1];
            selfWeak.tempModel.is_praise = YES;
        } else {
            selfWeak.tempModel.praise_num = [NSString stringWithFormat:@"%ld", (selfWeak.tempModel.praise_num.integerValue)-1];
            selfWeak.tempModel.is_praise = NO;

        }
        [selfWeak.commentView configData:selfWeak.tempModel];
        
    };
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(adaptHeight1334(10));
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(120));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(30) * 2);
        make.top.equalTo(self.userInfoView.mas_bottom);
        
    }];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.readLabel.mas_bottom).offset(adaptHeight1334(20));
        
    }];

    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(60));
        
    }];
    
}

- (void)configModelData:(TimelineModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempModel = model;
    _tempIndexPath = indexPath;
    [self.userInfoView configData:model];
    self.contentLabel.text = model.content;
    if ([self.viewController isKindOfClass:[TimelineDetailViewController class]]) {
        self.commentView.hidden = YES;
        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.lineView.mas_bottom);
            make.height.mas_equalTo(0);
            
        }];
    } else {
        self.commentView.hidden = NO;
        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.lineView.mas_bottom);
            make.height.mas_equalTo(adaptHeight1334(60));
            
        }];
        [self.commentView configData:model];
    }
    
    if (model.read_num.integerValue < 10000) {
        self.readLabel.text = [NSString stringWithFormat:@"%@阅读",model.read_num];
    } else if (model.read_num.integerValue > 10000 && model.read_num.integerValue < 100000){
        self.readLabel.text = [NSString stringWithFormat:@"%.1f万阅读",model.read_num.integerValue / 10000.0];
    } else {
        self.readLabel.text = [NSString stringWithFormat:@"%ld万阅读",model.read_num.integerValue / 100000];
    }
    
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _headView;
}

- (UserView *)userInfoView
{
    if (!_userInfoView) {
        _userInfoView = [UserView new];
    }
    return _userInfoView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(34) textColorString:COLOR060606];
        _contentLabel.numberOfLines = 10;
    }
    return _contentLabel;
}

- (UILabel *)readLabel
{
    if (!_readLabel) {
        _readLabel = [UILabel labWithText:@"51万阅读" fontSize:adaptFontSize(24) textColorString:COLOR999999];
    }
    return _readLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    }
    return _lineView;
}

- (UIView *)commentView
{
    if (!_commentView) {
        _commentView = [CommentFooterView new];
        
    }
    return _commentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
