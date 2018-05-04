//
//  NewsCommentModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsCommentModel.h"

@implementation NewsCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"comment_id" : @"id"};
}

@end
