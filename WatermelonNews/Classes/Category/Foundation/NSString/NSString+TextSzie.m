//
//  NSString+TextSzie.m
//  chuanzhi -QQ聊天
//
//  Created by yedexiong20 on 14/11/26.
//  Copyright (c) 2014年 ydx. All rights reserved.
//

#import "NSString+TextSzie.h"


@implementation NSString (TextSzie)

-(CGSize)textSzieWithFont:(UIFont*)font andMaxSzie:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}


@end
