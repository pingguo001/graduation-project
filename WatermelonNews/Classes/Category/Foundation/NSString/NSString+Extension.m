//
//  NSString+Extension.m
//  SailProject
//
//  Created by 刘永杰 on 2017/2/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>
#include <zlib.h>


//随意的加签字符串
NSString *const saltStr = @"jkemdtmvkfhute";

@implementation NSString (Extension)


#pragma mark == MD5加密算法

/**
 MD5加密   32位小写
 */
+ (NSString *)MD5Of32BitLowerString:(NSString *)string;
{
    const char *data = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
         [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
    
}

/**
 MD5加密   32位大写
 */
+ (NSString *)MD5Of32BitUpperString:(NSString *)string
{
    const char *data = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5Str appendFormat:@"%02X", result[i]];
    }
    return md5Str;
}

/**
 MD5加密   16位小写
 */
+ (NSString *)MD5Of16BitLowerString:(NSString *)string
{
    return [[self MD5Of32BitLowerString:string] substringWithRange:NSMakeRange(8, 16)];
}

/**
 MD5加密   16位大写
 */
+ (NSString *)MD5Of16BitUpperString:(NSString *)string
{
    return [[self MD5Of32BitUpperString:string] substringWithRange:NSMakeRange(8, 16)];
}

/**
 MD5加盐再加密
 */
+ (NSString *)MD5AndSaltString:(NSString *)string
{
    return [self MD5Of32BitLowerString:[string stringByAppendingString:saltStr]];
    
}

/**
 MD5加密后乱序
 */
+ (NSString *)MD5AndDerangementString:(NSString *)string
{
    NSString *str = [self MD5Of32BitLowerString:string];
    NSString *header = [str substringToIndex:3];
    NSString *footer = [str substringFromIndex:3];
    
    return [footer stringByAppendingString:header];
}

+ (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
