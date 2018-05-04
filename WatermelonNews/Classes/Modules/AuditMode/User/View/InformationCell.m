//
//  InformationCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformationCell.h"
#import "InfomationModel.h"

@interface InformationCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation InformationCell

- (void)p_setupViews
{
    
    self.titleLabel = [UILabel labWithText:@"头像" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:self.titleLabel];
    
    self.headImageView = [UIImageView new];
    self.headImageView.image = [UIImage imageNamed:@"edit_avatar"];
    self.headImageView.layer.cornerRadius = adaptHeight1334(100)/2.0;
    self.headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    
    self.infoLabel = [UILabel labWithText:@"用户1234" fontSize:adaptFontSize(30) textColorString:COLOR999999];
    [self.contentView addSubview:self.infoLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(34));
        
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-adaptWidth750(64));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(adaptHeight1334(100));
        
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-adaptWidth750(64));
        make.centerY.equalTo(self.contentView);
        
    }];
    
}

- (void)configModelData:(InfomationModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.titleLabel.text = model.title;
    
    if (indexPath.section == 1) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.infoLabel.hidden = YES;
        self.headImageView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            
        }];
        self.titleLabel.text = @"退出登录";
        self.titleLabel.textColor = [UIColor redColor];

    } else {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.infoLabel.hidden = NO;
        self.headImageView.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(adaptWidth750(34));
            
        }];
        self.titleLabel.textColor = [UIColor colorWithString:COLOR333333];

    }
    
    if (indexPath.row == 0) {
        self.infoLabel.hidden = YES;
        if (indexPath.section == 1) {
            self.headImageView.hidden = YES;
        } else {
            self.headImageView.hidden = NO;
        }
        if (model.info != nil) {
            if ([model.info containsString:@"http:"] ||[model.info containsString:@"https:"] ) {
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.info] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];
                
            } else {
                
                self.headImageView.image = [UIImage imageWithContentsOfFile:model.info];
            }
        } else {
            self.headImageView.image = [UIImage imageNamed:@"edit_avatar"];
        }
        
    } else {
        self.infoLabel.hidden = NO;
        self.headImageView.hidden = YES;
        if (model.info == nil || model.info.length == 0) {
            
            self.infoLabel.textColor = [UIColor colorWithString:COLOR39AF34];
            self.infoLabel.text = @"待完善";
            
        } else {
            
            self.infoLabel.textColor = [UIColor colorWithString:COLOR999999];
            self.infoLabel.text = model.info;
        }
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
