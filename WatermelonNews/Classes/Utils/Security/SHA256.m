//
// Created by Zhangziqi on 4/11/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SHA256.h"


@implementation SHA256

/**
 *  获取 SHA256 摘要
 *
 *  @param raw 待处理的 NSString 对象
 *
 *  @return SHA256 摘要
 */
+ (NSString *_Nonnull)hash:(NSString *_Nonnull)raw {
    const char *str = [raw UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG) strlen(str), result);

    NSMutableString *out = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [out appendFormat:@"%02x", result[i]];
    }
    
    return out;
//    const char *s=[raw cStringUsingEncoding:NSASCIIStringEncoding];
//    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
//    
//    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
//    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
//    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
//    NSString *hash=[out description];
//    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
//    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
//    return hash;
}

@end