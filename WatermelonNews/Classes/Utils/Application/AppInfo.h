//
//  AppInfo.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/13.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

/**
 *  获取应用名称
 *
 *  @return 应用名称
 */
+ (NSString *_Nonnull)name;

/**
 *  获取应用版本号
 *
 *  @return 应用版本号
 */
+ (NSString *_Nonnull)version;

/**
 *  获取应用Build号
 *
 *  @return 应用Build号
 */
+ (NSString *_Nonnull)build;


/**
 获取应用bundleID

 @return 应用bundleID
 */
+ (NSString *_Nullable)bundleID;

@end
