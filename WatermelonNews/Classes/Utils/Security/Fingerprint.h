//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Fingerprint : NSObject

/**
 *  根据idfa、key1、key2生成签名
 *
 *  @param key1  格式为数字的字符串，外部输入为时间戳的偶数位
 *  @param key2  格式为数字的字符串，外部输入为时间戳的奇数位
 *  @param idfa  设备的idfa
 *
 *  @return 生成的签名
 */
+ (NSString *_Nonnull)generateWithIdfa:(NSString *_Nonnull)idfa
                                  key1:(NSString *_Nonnull)key1
                                  key2:(NSString *_Nonnull)key2;


/**
 根据idfa、设备型号、包名生成签名

 @param idfa 设备idfa
 @return 生产的Account签名
 */
+ (NSString *_Nullable)generateAccountWithIdfa:(NSString *_Nullable)idfa;

/**
 根据idfa、屏幕尺寸生成key

 @param idfa 设备idfa
 @return 生成key签名
 */
+ (NSString *_Nullable)generateKeyWithIdfa:(NSString *_Nullable)idfa;

/**
 根据idfa生成Signature
 
 @param idfa 设备idfa
 @param timestamp 时间戳

 @return 生成Signature签名
 */
+ (NSString *_Nullable)generateSignatureWithIdfa:(NSString *_Nullable)idfa timestamp:(NSString *_Nullable)timestamp;




@end
