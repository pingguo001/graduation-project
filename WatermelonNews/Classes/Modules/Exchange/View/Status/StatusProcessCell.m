//
//  StatusProcessCell.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/15.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "StatusProcessCell.h"
#import "StatusModel.h"

@interface StatusProcessCell ()

@property (strong, nonatomic) UIImageView *dynamicLineView;
@property (strong, nonatomic) UIImageView *dynamicIconView;

@property (strong, nonatomic) UILabel *statusTitleLabel;
@property (strong, nonatomic) UILabel *statusContentLabel;

@property (strong, nonatomic) UILabel *resultTitleLabel;
@property (strong, nonatomic) UILabel *resultContentLabel;

@end

@implementation StatusProcessCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLabel = [UILabel labWithText:@"处理进度：" fontSize:adaptFontSize(28) textColorString:COLOR666666];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *statusImageView = [UIImageView new];
    statusImageView.image = [UIImage imageNamed:@"state_suc"];
    [self.contentView addSubview:statusImageView];
    
    UIImageView *statusLineView = [UIImageView new];
    statusLineView.image = [UIImage imageNamed:@"state_line_mo"];
    [self.contentView addSubview:statusLineView];
    
    _dynamicLineView = [UIImageView new];
    _dynamicLineView.image = [UIImage imageNamed:@"state_line_gray"];
    [self.contentView addSubview:_dynamicLineView];
    
    _dynamicIconView = [UIImageView new];
    _dynamicIconView.image = [UIImage imageNamed:@"state_arr"];
    [self.contentView addSubview:_dynamicIconView];
    
    _statusTitleLabel = [UILabel labWithText:@"提交提现申请" fontSize:adaptFontSize(32) textColorString:COLOR39AF34];
    [self.contentView addSubview:_statusTitleLabel];
    
    _statusContentLabel = [UILabel labWithText:@"申请提现时间:\n提现类型:\n提现金额:\n提现账号:" fontSize:adaptFontSize(28) textColorString:COLOR999999];
    _statusContentLabel.numberOfLines = 0;
    [self.contentView addSubview:_statusContentLabel];
    
    _resultTitleLabel = [UILabel labWithText:@"恭喜你，提现成功" fontSize:adaptFontSize(32) textColorString:COLOR39AF34];
    [self.contentView addSubview:_resultTitleLabel];
    
    _resultContentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR999999];
    _resultContentLabel.numberOfLines = 0;
    [self.contentView addSubview:_resultContentLabel];
    
    UIImageView *lineView = [UIImageView new];
    lineView.image = [UIImage imageNamed:@"state_line_do"];
    [self.contentView addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(40));
        
    }];
    
    [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(adaptWidth750(4));
        
    }];
    
    [statusLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(statusImageView);
        make.top.equalTo(statusImageView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(90));
        
    }];
    
    [_dynamicLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(statusLineView);
        make.top.equalTo(statusLineView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(90));
    }];
    
    [_dynamicIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dynamicLineView);
        make.top.equalTo(_dynamicLineView.mas_bottom);
    }];
    
    [_statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(statusImageView);
        make.left.equalTo(statusImageView.mas_right).offset(adaptWidth750(20));
        
    }];
    
    [_statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_statusTitleLabel.mas_bottom).offset(adaptHeight1334(10));
        make.left.equalTo(_statusTitleLabel);
        
    }];
    
    [_resultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_dynamicIconView);
        make.left.equalTo(_statusContentLabel);
    }];
    
    [_resultContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_resultTitleLabel.mas_bottom).offset(adaptHeight1334(10));
        make.left.equalTo(_resultTitleLabel);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_resultContentLabel.mas_bottom).offset(adaptHeight1334(36));
        make.left.equalTo(titleLabel);
        make.right.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        make.bottom.equalTo(self.contentView);
        
    }];
    
}

- (void)configModelData:(StatusModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray = @[@"申请提现时间：", @"提现类型：", @"提现金额：", @"提现账号："];
    NSArray *contentArray;
    if (model.createdAt == nil || model.account == nil) {
        contentArray = @[@"2017-01-01 18:24:58", @"支付宝", @"50元", @"12345678901"].mutableCopy;
    } else {
        contentArray  = @[model.createdAt, @"支付宝", [NSString stringWithFormat:@"%@元", model.checkMoney], model.account].mutableCopy;
    }
    
    // 日期格式化类
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    format1.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    format2.dateFormat = @"MM月dd日HH:mm";
    
    NSDate *date = [format1 dateFromString:model.createdAt];
    
    NSDate *sinceCustomDate = [date initWithTimeInterval:24*60*60 sinceDate:date];
    NSString *newString = [format2 stringFromDate:sinceCustomDate];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        NSString *str = [titleArray[i] stringByAppendingString:contentArray[i]];
        [resultArray addObject:str];
    }
    _statusContentLabel.text = [resultArray componentsJoinedByString:@"\n"];
    [self setContentData:_statusContentLabel.text withStrArray:contentArray.mutableCopy];
    
    switch (model.flag.integerValue) {
        case 0: {  //提现中
            _dynamicLineView.image = [UIImage imageNamed:@"state_line_gray"];
            _dynamicIconView.image = [UIImage imageNamed:@"state_arr"];
            _resultTitleLabel.text = [NSString stringWithFormat:@"预计%@前到账",newString];
            _resultContentLabel.text = @"\n\n";
            _resultTitleLabel.textColor = [UIColor colorWithString:COLORAEAEAE];
            break;
        }
        case 1: {  //提现成功
            _dynamicLineView.image = [UIImage imageNamed:@"state_line_mo"];
            _dynamicIconView.image = [UIImage imageNamed:@"state_green"];
            _resultTitleLabel.text = @"恭喜你，提现成功";
            _resultContentLabel.text = @"财务MM昼夜不停地帮你提现了！\n都熬出黑眼圈了，喵~\n来赏个好评吧^_^\n";
            _resultTitleLabel.textColor = [UIColor colorWithString:COLOR39AF34];
            break;
        }
        case 2: {  //提现失败
            _dynamicLineView.image = [UIImage imageNamed:@"state_line_hot"];
            _dynamicIconView.image = [UIImage imageNamed:@"state_delete"];
            _resultTitleLabel.text = @"非常抱歉，提现失败";
            _resultContentLabel.text = @"我们已经把提现金额打回您的余额\n中了！\n";
            _resultTitleLabel.textColor = [UIColor colorWithString:COLORFF5A5D];
            break;
        }
    }
    [self setContentLineHeightWithLabel:_resultContentLabel];

}

- (void)setContentLineHeightWithLabel:(UILabel *)contentLabel
{
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:contentLabel.text attributes:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
    [contentLabel setAttributedText:attributedString];
    [contentLabel sizeToFit];
}

//富文本
- (void)setContentData:(NSString *)str withStrArray:(NSMutableArray *)strArray
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [strArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithString:COLOR333333]} range:[str rangeOfString:obj]];
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    _statusContentLabel.attributedText = attributeString;
}

@end
