//
//  UILabel+Extension.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/6/22.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorString:(NSString *)textColorString
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithString:textColorString];
    return label;
}

@end
