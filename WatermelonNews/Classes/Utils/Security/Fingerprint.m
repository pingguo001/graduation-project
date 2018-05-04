//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "Fingerprint.h"
#import "SHA256.h"
#import "Xor.h"
#import "Base64.h"
#import "NSString+Split.h"
#import "UIDevice+Info.h"
#import "NSString+Extension.h"
#import "AppInfo.h"

@implementation Fingerprint

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
                                  key2:(NSString *_Nonnull)key2 {
    NSInteger key1Num = [key1 integerValue];
    NSInteger key2Num = [key2 integerValue];
    NSInteger difference;

    if (key1Num > key2Num) {
        difference = key1Num - key2Num;
    } else {
        difference = key2Num - key1Num;
    }

    NSMutableString *plain = [idfa mutableCopy];
    [plain appendFormat:@"%ld", (long) difference];

    NSString *subKey = [NSString stringWithFormat:@"%@%@", key2, key1];
    NSMutableString *key = [[NSMutableString alloc] init];

    while (key.length < plain.length) {
        [key appendString:subKey];
    }

    key = [[key substringWithRange:NSMakeRange(0, plain.length)] mutableCopy];

    NSString *cipher = [Base64 encodeString:[Xor xor:plain with:key]
                               withEncoding:NSUTF8StringEncoding];

    return [SHA256 hash:cipher];
}

/**
 根据idfa、设备型号、包名生产签名
 
 @param idfa 设备idfa
 @return 生产的签名
 */
+ (NSString *_Nullable)generateAccountWithIdfa:(NSString *_Nullable)idfa
{
    //identifier 设备型号
    //packageName 包名（写死 com.xigua.infoflow）规则：去掉点做倒序
    NSString *identifier = [[UIDevice currentDevice] identifier];
    NSString *packageName = [AppInfo bundleID];
    NSString *reservePackageName = [NSString reverseWordsInString:[packageName stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
    return [SHA256 hash:[[idfa stringByAppendingString:identifier] stringByAppendingString:reservePackageName]];
}

/**
 根据idfa、屏幕尺寸生成key
 
 @param idfa 设备idfa
 @return 生成key签名
 */
+ (NSString *_Nullable)generateKeyWithIdfa:(NSString *_Nullable)idfa
{
    NSString *screen = [NSString stringWithFormat:@"%@x%@", [[UIDevice currentDevice] screenWidth], [[UIDevice currentDevice] screenHeight]];
    NSString *cpu = [UIDevice currentDevice].identifier;
    
    return [SHA256 hash:[[idfa stringByAppendingString:cpu] stringByAppendingString:screen]];
    }

/**
 根据idfa生成Signature
 
 @param idfa 设备idfa
 @return 生成Signature签名
 */
+ (NSString *_Nullable)generateSignatureWithIdfa:(NSString *_Nullable)idfa timestamp:(NSString *)timestamp
{
    NSString *account = [self generateAccountWithIdfa:idfa];
    NSString *key = [self generateKeyWithIdfa:idfa];
    
    NSInteger length = account.length + key.length;
    
    NSString *sb = timestamp.mutableCopy;
    while (sb.length < length) {
        
        sb = [NSString stringWithFormat:@"%@%@", sb,sb];
    }
    NSString *keyTime = [sb substringWithRange:NSMakeRange(0, length)];
    NSString *accoutKey = [NSString stringWithFormat:@"%@%@", account, key];
    
    NSString *cipher = [Base64 encodeString:[Xor xor:keyTime with:accoutKey]
                               withEncoding:NSUTF8StringEncoding];
    
    return  [NSString MD5Of32BitLowerString:[NSString MD5Of32BitLowerString:cipher]];
}


@end
