//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Keychain : NSObject
+ (void)log;

+ (void)storeStringValue:(NSString *_Nonnull)value withKey:(NSString *_Nonnull)key;

+ (NSString *_Nullable)takeStringValueWithKey:(NSString *_Nonnull)key;

+ (BOOL)removeValueForKey:(NSString * _Nonnull)key;
@end