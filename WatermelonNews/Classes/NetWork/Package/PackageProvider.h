//
//  PackageProvider.h
//  Kratos
//
//  Created by Zhangziqi on 3/28/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Package;

typedef void (^Completion)(NSArray<Package *> * _Nonnull result);

@interface PackageProvider : NSObject


/**
*  从数据库获取本地安装的所有App，不一定时时更新
*
*  @param completion 获取完成时的回调
*/
+ (void)fullPackagesWithCompletion:(_Nonnull Completion)completion;

/**
 *  获取本地新安装的App，并保存到数据库中
 *
 *  @param completion 获取完成时的回调
 */
+ (void)incrementalPackagesWithCompletion:(_Nonnull Completion)completion;

/**
 *  根据应用的bundle executable查找包的信息
 *
 *  内部采取了缓存的方式实现，首先会在缓存内查找，缓存内查找到返回，查找不到会去数据库查找，并保存在缓存中
 *
 *  @param bundleExecutables 应用的bundle executable数组
 *  @param completion 查询完成时的回调，因为可能涉及到数据库操作，所以查询是异步的
 *
 */
+ (void)findPackagesWithBundleExecutables:(NSArray *_Nonnull)bundleExecutables
                           withCompletion:(void (^ _Nonnull)(NSArray<Package *> *_Nullable))completion;

/**
 *  获取当前安装的所有App
 *
 *  @return App集合
 */
+ (NSArray<Package *> *_Nonnull)localPackages;
@end
