//
//  NSString+TextSzie.h
//  chuanzhi -QQ聊天
//
//  Created by yedexiong20 on 14/11/26.
//  Copyright (c) 2014年 ydx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (TextSzie)

//计算文字尺寸大小
-(CGSize)textSzieWithFont:(UIFont*)font andMaxSzie:(CGSize)size;

@end
