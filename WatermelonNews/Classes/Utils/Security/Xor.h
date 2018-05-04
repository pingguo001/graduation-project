//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Xor : NSObject
/**
 *  异或加密
 *
 *  @param aStr 字符串
 *  @param bStr 字符串
 *
 *  @return 异或结果
 */
+ (NSString *_Nonnull)xor:(NSString *_Nonnull)aStr with:(NSString *_Nonnull)bStr;
@end