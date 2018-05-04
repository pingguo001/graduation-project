//
//  CommentModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/7.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId" : @"id"};
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    _praise_num = [NSString stringWithFormat:@"%u",arc4random()%99];
    
}

@end
