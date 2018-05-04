//
//  PackageManager.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/6.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorResolver.h"

@interface PackageManager : NSObject
@property (nonatomic, strong) ErrorResolver * _Nullable resolver; /**< 发生错误时，调用其进行处理 */

/**
 *  上传本地安装的APP
 */
- (void)uploadDevicePackage;

/**
 *  判断App是否安装
 *
 *  @param bundleId App的BundleId
 *
 *  @return 是否安装
 */
+ (BOOL)isAppInstalled:(NSString *_Nonnull)bundleId;

/**
 *  打开App
 *
 *  @param bundleId App的BundleId
 */
+ (BOOL)openApp:(NSString *_Nonnull)bundleId;

@end
