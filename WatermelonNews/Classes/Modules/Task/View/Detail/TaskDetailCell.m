//
//  TaskDetailCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskDetailCell.h"
#import "TaskDetailModel.h"

@interface TaskDetailCell ()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation TaskDetailCell

- (void)p_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _contentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(26) textColorString:COLOR4E6270];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).offset(adaptWidth750(kSpecWidth));
        make.right.bottom.equalTo(self.contentView).offset(-adaptWidth750(kSpecWidth));
        
    }];
}

- (void)configModelData:(TaskDetailModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *guidesArray = [NSMutableArray array];
    NSMutableArray *attriArray = [NSMutableArray array];
    [model.guides enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        NSMutableString *mutStr = obj.mutableCopy;

        if ([mutStr containsString:@"</font>"]) {
            
            NSRange startRange = [mutStr rangeOfString:@"<font color=\"red\">"];
            NSRange endRange = [mutStr rangeOfString:@"</font>"];
            
            //需要设置富文本的字符串
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [mutStr substringWithRange:range];
            [attriArray addObject:result];
            
            //将设置的说明截除掉
            NSString *sub = [mutStr substringWithRange:NSMakeRange(startRange.location, endRange.location-startRange.location+7)];
            NSString *resultStr = [mutStr stringByReplacingOccurrencesOfString:sub withString:result];
            
            [guidesArray addObject:[NSString stringWithFormat:@"%lu. %@", idx + 1, resultStr]];

            
        } else {
            
            [guidesArray addObject:[NSString stringWithFormat:@"%lu. %@", idx + 1, mutStr]];
        }
        

    }];

    _contentLabel.text = [guidesArray componentsJoinedByString:@"\n"];
    _contentLabel.numberOfLines = guidesArray.count;
    [self setContentData:_contentLabel.text withStrArray:attriArray];
}

//富文本
- (void)setContentData:(NSString *)str withStrArray:(NSMutableArray *)strArray
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [strArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:obj]];
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(10)];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    _contentLabel.attributedText = attributeString;
}

@end
