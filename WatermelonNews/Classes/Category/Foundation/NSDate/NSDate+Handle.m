//
//  NSDate+Handle.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NSDate+Handle.h"

@implementation NSDate (Handle)

+ (NSString *)dateConversionWithDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval t = [nowDate timeIntervalSinceDate:date];
    
    if(t/60 < 2) {
        
        return @"刚刚";
        
    } else if(t/60 > 2 && t/60 < 60) {
        
        return [NSString stringWithFormat:@"%.0f分钟前", t/60];
        
    } else if (t/3600 < 24) {
        
        return [NSString stringWithFormat:@"%.0f小时前", t/3600];
        
    } else if ( t/(24 * 3600) >= 1 && t/(24 * 3600) <= 2 ){
        
        return @"昨天";
        
    } else if ( t/(24 * 3600) > 2 && t/(24 * 3600) <= 3 ){
        
        return @"前天";
        
    } else if (t/(24*3600) > 2) {
        
        return [NSString stringWithFormat:@"%.0f天前", t/(24*3600)];
    }
    return NULL;
}

@end
