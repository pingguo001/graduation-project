//
//  GoogleNativeAdCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GoogleNativeAdCell.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleAdModel.h"
#define kImageHeight adaptHeight1334(350)

@interface GoogleNativeAdCell ()

@property (weak, nonatomic) IBOutlet GADNativeAppInstallAdView *nativeAdView;

@property (weak, nonatomic) IBOutlet GADNativeContentAdView *nativeContentAdView;

@property (strong, nonatomic) UILabel *adLabel;
@property (assign, nonatomic) NSIndexPath *tempIndexPath;

@end

@implementation GoogleNativeAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupViews];
}

- (void)setupViews
{
    
    //设置安装APP的广告View
    [self setupAdView:self.nativeAdView];
    
    //设置内容的广告View
    [self setupAdView:self.nativeContentAdView];
}

- (void)setupAdView:(UIView *)view
{
    GADNativeAppInstallAdView *adView;
    if ([view isKindOfClass:[GADNativeAppInstallAdView class]]) {
        adView = self.nativeAdView;
    } else {
        adView = self.nativeContentAdView;
    }
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [adView addSubview:lineView];
    
    self.adLabel = [UILabel labWithText:@"广告" fontSize:adaptFontSize(20) textColorString:COLOR39AF34];
    [adView addSubview:self.adLabel];
    self.adLabel.layer.borderColor = [UIColor colorWithString:COLOR39AF34].CGColor;
    self.adLabel.layer.borderWidth = 0.5;
    self.adLabel.layer.cornerRadius = adaptHeight1334(6);
    self.adLabel.layer.masksToBounds = YES;
    self.adLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"adv_delete"] forState:UIControlStateNormal];
    [adView addSubview:button];
    [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.top.bottom.equalTo(adView.bodyView);
        make.width.mas_equalTo(adaptWidth750(60));
        
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.adLabel);
        make.right.equalTo(adView.headlineView);
        make.width.equalTo(self.adLabel);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(adView);
        make.height.mas_equalTo(0.5);
        
    }];
    
    ((UILabel *)adView.headlineView).font = [UIFont systemFontOfSize:adaptFontSize(36)];
    ((UILabel *)adView.headlineView).numberOfLines = 0;
    ((UILabel *)adView.headlineView).textColor = [UIColor colorWithString:COLOR060606];
    
    ((UILabel *)adView.bodyView).font = [UIFont systemFontOfSize:adaptFontSize(24)];
    ((UILabel *)adView.bodyView).textColor = [UIColor colorWithString:COLORA9A9A9];
    
    [adView.headlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(adaptWidth750(25));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26));
        
    }];
    
    [adView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(adView.headlineView);
        make.top.equalTo(adView.headlineView.mas_bottom).offset(adaptHeight1334(25));
        make.height.mas_equalTo(kImageHeight);
        
    }];
    
    [adView.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(adView.imageView.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.adLabel.mas_right).offset(adaptWidth750(16));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(34));
        make.right.equalTo(adView.headlineView);
        
    }];
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath
{
    _tempIndexPath = indexPath;
    GADNativeAppInstallAd * ad = [(GoogleAdModel *)model raw];
    
    if ([ad isKindOfClass:[GADNativeAppInstallAd class]]) {
        self.nativeContentAdView.hidden = YES;
        self.nativeAdView.hidden = NO;
        self.nativeAdView.nativeAppInstallAd = ad;
        ((UILabel *)self.nativeAdView.headlineView).text = ad.body;
        ((UILabel *)self.nativeAdView.bodyView).text = ad.headline;
        GADNativeAdImage *firstImage = ad.images.firstObject;
        ((UIImageView *)self.nativeAdView.imageView).image = firstImage.image;
    } else {
        self.nativeContentAdView.hidden = NO;
        self.nativeAdView.hidden = YES;
        self.nativeContentAdView.nativeContentAd = ad;
        ((UILabel *)self.nativeContentAdView.headlineView).text = ad.body;
        ((UILabel *)self.nativeContentAdView.bodyView).text = ad.headline;
        GADNativeAdImage *firstImage = ad.images.firstObject;
        ((UIImageView *)self.nativeContentAdView.imageView).image = firstImage.image;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock(_tempIndexPath);
    }
}

@end
