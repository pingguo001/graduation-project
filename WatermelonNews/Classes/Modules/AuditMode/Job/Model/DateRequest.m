//
//  DateRequest.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/10/13.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "DateRequest.h"

@implementation DateRequest

+ (NSString *)getTime:(NSString *)time{
    NSString *dayTime = [time substringWithRange:NSMakeRange(8, 2)];
    NSInteger row = [dayTime intValue];
    row--;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    currentTime -= (60*60*24)*row ;
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:currentTime];
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"YYYY年MM月dd日"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}

@end
