//
//  TaskAdModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskAdModel.h"

@implementation TaskAdModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"taskId":@"id",
             };
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    self.source = TaskAdType;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
