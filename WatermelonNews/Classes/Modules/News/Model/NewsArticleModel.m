//
//  NewsArticleModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsArticleModel.h"

@implementation NewsArticleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"articleId" : @"id",
             @"encryptId" : @"sid"};
}

- (void)setCreated_at:(NSString *)created_at
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    _created_at = [formatter stringFromDate:[NSDate date]];
}

@end
