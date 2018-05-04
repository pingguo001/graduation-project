//
//  AppInfo.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/13.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

/**
 *  获取应用名称
 *
 *  @return 应用名称
 */
+ (NSString *_Nonnull)name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/**
 *  获取应用版本号
 *
 *  @return 应用版本号
 */
+ (NSString *_Nonnull)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  获取应用Build号
 *
 *  @return 应用Build号
 */
+ (NSString *_Nonnull)build {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


/**
 获取bundleID

 @return bundleID
 */
+ (NSString *)bundleID{
    
    return [[NSBundle mainBundle] bundleIdentifier];
}

@end
