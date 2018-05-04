//
//  TencentAdCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TencentAdCell.h"
#import "TencentAdModel.h"
#import "NSDate+Handle.h"
#import "GDTNativeExpressAdView.h"
#import "GDTNativeExpressAdView+Extention.h"
#import "NewsDetailViewController.h"


#define kImageHeight adaptHeight1334(300)

@interface TencentAdCell ()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *adLabel;
@property (assign, nonatomic) NSIndexPath *tempIndexPath;
@property (strong, nonatomic) UIView *adView;
@property (strong, nonatomic) UIView *specView;

@end

@implementation TencentAdCell

- (void)p_setupViews
{
    [super p_setupViews];
    self.specView = [UIView new];
    self.specView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.specView];
    self.specView.layer.borderWidth = 0.5;
    self.specView.layer.borderColor = [UIColor colorWithString:COLORE1E1DF].CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.specView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-adaptHeight1334(30));
        
    }];
    
    return;
    
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"adv_delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
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

- (void)configModelData:(TencentAdModel *)model indexPath:(NSIndexPath *)indexPath
{
    if ([model.expressAdType isEqualToString:adType1]) {
        
        if ([model.expressAdView.controller isKindOfClass:[NewsDetailViewController class]]) {
            model.expressAdView.frame = CGRectMake(adaptWidth750(15)+1, 2, self.width, self.height-adaptHeight1334(30));
            self.specView.hidden = NO;
        } else {
            self.specView.hidden = YES;
            model.expressAdView.frame = CGRectMake(0, 0, self.width, self.height);
        }

    } else {
        
        model.expressAdView.frame = CGRectMake(5, 5, self.width - 20, self.height);

    }
    [TalkingDataApi trackEvent:TD_SHOW_TENCENTAD];

    model.expressAdView.deleteBlock = self.deleteBlock;
    
    [model.expressAdView render];
    //添加View的时机，开发者控制
    [self.contentView addSubview:model.expressAdView];
    
    
    return;
    
//    _tempIndexPath = indexPath;
//    self.titleLabel.text = model.desc;
//    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:nil];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:adaptHeight1334(6)];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.titleLabel.text.length)];
//    [self.titleLabel setAttributedText:attributedString];
//    [self.titleLabel sizeToFit];
//    
//    self.detailLabel.text = model.title;
//    self.detailLabel.text = [NSString stringWithFormat:@"%@  %@",model.title,[NSDate dateConversionWithDateString:model.created_at]];
//
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"xinwenbg"]];
//    [self setContentDidRed:model.isRead];

}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock();
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
