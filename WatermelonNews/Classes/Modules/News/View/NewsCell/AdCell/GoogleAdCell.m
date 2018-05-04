//
//  GoogleAdCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GoogleAdCell.h"
#import "GoogleAdModel.h"
#import "NSDate+Handle.h"

#define kImageHeight adaptHeight1334(350)

@interface GoogleAdCell ()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *adLabel;
@property (assign, nonatomic) NSIndexPath *tempIndexPath;
@property (strong, nonatomic) UIView *adView;
@property (strong, nonatomic) GADNativeAppInstallAdView *placeView;

@end

@implementation GoogleAdCell

- (void)p_setupViews
{
    [super p_setupViews];
    
    self.imgView = [UIImageView new];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imgView];
    
    self.adLabel = [UILabel labWithText:@"广告" fontSize:adaptFontSize(20) textColorString:COLOR39AF34];
    [self.contentView addSubview:self.adLabel];
    self.adLabel.layer.borderColor = [UIColor colorWithString:COLOR39AF34].CGColor;
    self.adLabel.layer.borderWidth = 0.5;
    self.adLabel.layer.cornerRadius = adaptHeight1334(6);
    self.adLabel.layer.masksToBounds = YES;
    self.adLabel.textAlignment = NSTextAlignmentCenter;
    
    self.placeView = [GADNativeAppInstallAdView new];
    [self.contentView addSubview:self.placeView];
    
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"adv_delete"] forState:UIControlStateNormal];
    [self.placeView addSubview:button];
    [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(adaptWidth750(25));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26));
        
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(25));
        make.height.mas_equalTo(kImageHeight);
        
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.adLabel.mas_right).offset(adaptWidth750(16));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(34));
        make.right.equalTo(self.titleLabel);
        
    }];
    
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.top.bottom.equalTo(self.detailLabel);
        make.width.mas_equalTo(adaptWidth750(60));
        
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.adLabel);
        make.right.equalTo(self.titleLabel);
        make.width.equalTo(self.adLabel);
        
    }];
    
}

- (void)configModelData:(GoogleAdModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.placeView.nativeAppInstallAd = model.raw;
    _tempIndexPath = indexPath;
    self.titleLabel.text = model.desc;
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.titleLabel.text.length)];
    [self.titleLabel setAttributedText:attributedString];
    [self.titleLabel sizeToFit];

    self.detailLabel.text = model.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%@  %@",model.title,[NSDate dateConversionWithDateString:model.created_at]];
    self.imgView.image = model.img;
    [self setContentDidRed:model.isRead];
    
}

- (void)deleteAction
{
    
}

@end
