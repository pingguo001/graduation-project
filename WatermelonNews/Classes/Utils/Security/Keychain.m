//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>
#import "Keychain.h"

#ifdef DEBUG
#define SERVICE @"com.lingyongqian.WatermelonNews.debug"
#else
#define SERVICE @"com.lingyongqian.WatermelonNews"
#endif

@implementation Keychain {

}

#ifdef DEBUG
+ (void)log {
    NSLog(@"%@", [UICKeyChainStore keyChainStoreWithService:SERVICE]);
}
#else
+ (void)log {
}
#endif

+ (void)storeStringValue:(NSString *_Nonnull)value withKey:(NSString *_Nonnull)key {
    [UICKeyChainStore keyChainStoreWithService:SERVICE][key] = value;
}

+ (NSString *_Nullable)takeStringValueWithKey:(NSString *_Nonnull)key {
    return [UICKeyChainStore keyChainStoreWithService:SERVICE][key];
}

+ (BOOL)removeValueForKey:(NSString * _Nonnull)key {
    return [UICKeyChainStore removeItemForKey:key service:SERVICE];
}

@end
