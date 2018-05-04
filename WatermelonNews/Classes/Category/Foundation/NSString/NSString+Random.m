//
//  NSString+Random.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "NSString+Random.h"

@implementation NSString (Random)

/**
 *  随机生成一个长度为8的字符串
 *
 *  @return 随机生成的字符串
 */
+ (NSString *_Nonnull)random {
    return [NSString randomWithLength:10];
}

/**
 *  根据给定长度生成随机字符串
 *
 *  @param length 要生成的随机字符串的长度
 *
 *  @return 随机生成的字符串
 */
+ (NSString *_Nonnull)randomWithLength:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    return randomString;
}

@end
