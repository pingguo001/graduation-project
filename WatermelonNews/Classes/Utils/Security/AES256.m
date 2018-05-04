//
// Created by Zhangziqi on 4/11/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

#import "AES256.h"
#import "Base64.h"
#import "UserManager.h"

const RNCryptorSettings kAES256Settings = {
    .algorithm = kCCAlgorithmAES128,
    .blockSize = kCCBlockSizeAES128,
    .IVSize = kCCBlockSizeAES128,
    .options = kCCOptionPKCS7Padding,
    .HMACAlgorithm = kCCHmacAlgSHA256,
    .HMACLength = CC_SHA256_DIGEST_LENGTH,
    
    .keySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 107
    },
    
    .HMACKeySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 107
    }
};

const RNCryptorSettings kAES256SettingsICC = {
    .algorithm = kCCAlgorithmAES128,
    .blockSize = kCCBlockSizeAES128,
    .IVSize = kCCBlockSizeAES128,
    .options = kCCOptionPKCS7Padding,
    .HMACAlgorithm = kCCHmacAlgSHA256,
    .HMACLength = CC_SHA256_DIGEST_LENGTH,
    
    .keySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 103
    },
    
    .HMACKeySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 103
    }
};

@implementation AES256

/**
 *  AES256 加密
 *
 *  @param plain 待加密的 NSString 对象
 *  @param key   密钥
 *
 *  @return 加密后的 NSString 对象
 */
+ (NSString *_Nullable)encryptString:(NSString *_Nonnull)plain withKey:(NSString *_Nonnull)key {
    NSData *cipher = [AES256 encryptData:[plain dataUsingEncoding:NSUTF8StringEncoding]
                                 withKey:key];
    if (cipher == nil) {
        return nil;
    }
    cipher = [Base64 encodeData:cipher];

    return [[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding];
}

/**
 *  AES256 加密
 *
 *  @param plain 待加密的 NSData 对象
 *  @param key   密钥
 *
 *  @return 加密后的 NSData 对象
 */
+ (NSData *_Nullable)encryptData:(NSData *_Nonnull)plain withKey:(NSString *_Nonnull)key {
    NSError *error = nil;
    NSData *cipher = [RNEncryptor encryptData:plain
                                 withSettings:[key isEqualToString:[UserManager currentUser].iccToken] ? kAES256SettingsICC : kAES256Settings
                                     password:key
                                        error:&error];
    if (error != nil) {
        NSLog(@"%@", [error description]);
    }

    return cipher;
}

/**
 *  AES256 解密
 *
 *  @param cipher 待解密的 NSString 对象
 *  @param key    密钥
 *
 *  @return 解密后的 NSString 对象
 */
+ (NSString *_Nullable)decryptString:(NSString *_Nonnull)cipher withKey:(NSString *_Nonnull)key {
    NSData *plain = [AES256 decryptData:[cipher dataUsingEncoding:NSUTF8StringEncoding]
                                withKey:key];
    if (plain == nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
}

/**
 *  AES256 解密
 *
 *  @param cipher 待解密的 NSData 对象
 *  @param key    密钥
 *
 *  @return 解密后的 NSData 对象
 */
+ (NSData *_Nullable)decryptData:(NSData *_Nonnull)cipher withKey:(NSString *_Nonnull)key {
    cipher = [Base64 decodeData:cipher];
    NSError *error = nil;
    NSData *plain = [RNDecryptor decryptData:cipher
                                withSettings:[key isEqualToString:[UserManager currentUser].iccToken] ? kAES256SettingsICC : kAES256Settings
                                    password:key
                                       error:&error];
    if (error != nil) {
        NSLog(@"%@", [error description]);
    }

    return plain;
}

@end
