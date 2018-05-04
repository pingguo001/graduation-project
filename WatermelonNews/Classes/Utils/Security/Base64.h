//
//  Base64.h
//  Kratos
//
//  Created by Zhangziqi on 4/12/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

/**
 *  使用 Base64 编码指定的 NSData 对象
 *
 *  @param data 要编码的对象
 *
 *  @return 编码后的 NSData 对象
 */
+ (NSData *_Nonnull)encodeData:(NSData *_Nonnull)data;

/**
 *  使用 Base64 编码指定的 NSString 对象
 *
 *  @param string   要编码的对象
 *  @param encoding NSString 对象的编码方式
 *
 *  @return 编码后的 NSString 对象
 */
+ (NSString *_Nonnull)encodeString:(NSString *_Nonnull)string
                      withEncoding:(NSStringEncoding)encoding;

/**
 *  使用 Base64 解码指定的 NSData 对象
 *
 *  @param data 要解码的对象
 *
 *  @return 解码后的 NSData 对象
 */
+ (NSData *_Nonnull)decodeData:(NSData *_Nonnull)data;

/**
 *  使用 Base64 解码指定的 NSString 对象
 *
 *  @param string   要解码的对象
 *  @param encoding NSString 对象的编码方式
 *
 *  @return 解码后的 NSString 对象
 */
+ (NSString *_Nonnull)decodeString:(NSString *_Nonnull)string
                      withEncoding:(NSStringEncoding)encoding;
@end
