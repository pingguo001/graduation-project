//
//  BaseNewsCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewsArticleModel.h"
#import "ArticleDatabase.h"

@interface BaseNewsCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setContentDidRed:(BOOL)isRed;

@end
