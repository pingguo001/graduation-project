//
//  NSString+Extension.h
//  SailProject
//
//  Created by 刘永杰 on 2017/2/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


#pragma mark == MD5加密算法

/**
 MD5加密   32位小写
 */
+ (NSString *)MD5Of32BitLowerString:(NSString *)string;

/**
 MD5加密   32位大写
 */
+ (NSString *)MD5Of32BitUpperString:(NSString *)string;

/**
 MD5加密   16位小写
 */
+ (NSString *)MD5Of16BitLowerString:(NSString *)string;

/**
 MD5加密   16位大写
 */
+ (NSString *)MD5Of16BitUpperString:(NSString *)string;

/**
 MD5加密后加盐再加密
 */
+ (NSString *)MD5AndSaltString:(NSString *)string;

/**
 MD5加密后乱序
 */
+ (NSString *)MD5AndDerangementString:(NSString *)string;

+ (NSString *)sha1:(NSString *)input;


@end
