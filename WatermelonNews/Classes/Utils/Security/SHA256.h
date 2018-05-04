//
// Created by Zhangziqi on 4/11/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHA256 : NSObject

/**
 *  获取 SHA256 摘要
 *
 *  @param raw 待处理的 NSString 对象
 *
 *  @return SHA256 摘要
 */
+ (NSString *_Nonnull)hash:(NSString *_Nonnull)raw;

@end