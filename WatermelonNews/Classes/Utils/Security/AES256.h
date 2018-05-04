//
// Created by Zhangziqi on 4/11/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES256 : NSObject

/**
 *  AES256 加密
 *
 *  @param plain 待加密的 NSString 对象
 *  @param key   密钥
 *
 *  @return 加密后的 NSString 对象
 */
+ (NSString *)encryptString:(NSString *)plain withKey:(NSString *)key;

/**
 *  AES256 加密
 *
 *  @param plain 待加密的 NSData 对象
 *  @param key   密钥
 *
 *  @return 加密后的 NSData 对象
 */
+ (NSData *)encryptData:(NSData *)plain withKey:(NSString *)key;

/**
 *  AES256 解密
 *
 *  @param cipher 待解密的 NSString 对象
 *  @param key    密钥
 *
 *  @return 解密后的 NSString 对象
 */
+ (NSString *)decryptString:(NSString *)cipher withKey:(NSString *)key;

/**
 *  AES256 解密
 *
 *  @param cipher 待解密的 NSData 对象
 *  @param key    密钥
 *
 *  @return 解密后的 NSData 对象
 */
+ (NSData *)decryptData:(NSData *)cipher withKey:(NSString *)key;

@end