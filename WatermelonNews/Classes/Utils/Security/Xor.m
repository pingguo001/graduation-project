//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "Xor.h"
#import "NSString+Split.h"

@implementation Xor

/**
 *  异或加密
 *
 *  @param aStr 字符串
 *  @param bStr 字符串
 *
 *  @return 异或结果
 */
+ (NSString *_Nonnull)xor:(NSString *_Nonnull)aStr with:(NSString *_Nonnull)bStr {
    NSData *aData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bData = [bStr dataUsingEncoding:NSUTF8StringEncoding];

    const char *aBytes = [aData bytes];
    const char *bBytes = [bData bytes];

    NSMutableData *xorData = [[NSMutableData alloc] init];
    
    for (int i = 0; i < aData.length; i++) {
        const char xorByte = aBytes[i] ^ bBytes[i];
        [xorData appendBytes:&xorByte length:1];
    }
    
    return [[NSString alloc] initWithData:xorData encoding:NSUTF8StringEncoding];
}

@end
