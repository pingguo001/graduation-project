//
//  UserDataStore.m
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "UserDataStore.h"
#import "Keychain.h"

@implementation UserDataStore

- (NSString *_Nullable)stringValueForKey:(NSString *_Nonnull)key {
    return [Keychain takeStringValueWithKey:key];
}

- (void)setStringValue:(NSString *_Nonnull)data forKey:(NSString *_Nonnull)key {
    [Keychain storeStringValue:data withKey:key];
}

- (void)clearValueForKey:(NSString *_Nonnull)key {
    [Keychain removeValueForKey:key];
}

@end
