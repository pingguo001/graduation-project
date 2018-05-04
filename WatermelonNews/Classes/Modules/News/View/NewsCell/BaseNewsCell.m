//
//  BaseNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseNewsCell.h"
#import "NSDate+Handle.h"

@implementation BaseNewsCell

- (void)p_setupViews
{
    //标题
    self.titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(36) textColorString:COLOR060606];
    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.titleLabel];
    
    //说明
    self.detailLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLORA9A9A9];
//    self.detailLabel.backgroundColor = [UIColor orangeColor];
    self.detailLabel.numberOfLines = 1;
    
    [self.contentView addSubview:self.detailLabel];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.contentView addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        
    }];
    

    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];//这句不可省略
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithString:COLORF9F8F5];
    
}

- (void)setContentDidRed:(BOOL)isRed
{
    self.titleLabel.textColor = [UIColor colorWithString: isRed ? COLORA9A9A9 : COLOR060606];
    
}

- (void)configModelData:(NewsArticleModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.titleLabel.text = model.title;
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.titleLabel.text.length)];
    [self.titleLabel setAttributedText:attributedString];
    [self.titleLabel sizeToFit];

    self.detailLabel.text = [NSString stringWithFormat:@"%@  %@评论  %@",model.source, model.comment_num,[NSDate dateConversionWithDateString:model.created_at]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
