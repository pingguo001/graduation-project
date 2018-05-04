//
//  DatabaseManager.h
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Package;

typedef void (^QueryCompletion)(NSArray<Package *> * _Nonnull result); /**< 查询操作的回调 */
typedef void (^AlterCompletion)(BOOL isSuccess); /**< 修改操作的回调 */

@interface DatabaseManager : NSObject

/**
 *  单例方法
 *
 *  @return DatabaseManager实例
 */
+ (_Nonnull instancetype)sharedInstance;

/**
 *  取出全量本地安装应用列表
 *
 *  @param complation 成功时的回调
 */
- (void)selectPackagesWithCompletion:(_Nonnull QueryCompletion)complation;

/**
 *  根据应用的 bundleExecutables 取出相应的应用
 *
 *  @param bundleExecutables  应用的short name，e.g. Wechat
 *  @param completion 成功时的回调
 */
- (void)selectPackagesWithBundleExecutables:(NSArray<NSString *> *_Nonnull)bundleExecutables
                                 completion:(_Nonnull QueryCompletion)completion;

/**
 *  插入单条手机安装的应用的数据
 *
 *  @param package    要插入的应用
 *  @param completion 完成时的回调，可能为空
 *
 *  TODO : 判断是否插入成功
 */
- (void)insertPackage:(Package * _Nonnull)package
       withCompletion:(_Nullable AlterCompletion)completion;

/**
 *  插入多条手机安装的应用的数据
 *
 *  @param packages    要插入的应用
 *  @param completion  完成时的回调，可能为空
 *
 *  TODO : 判断是否插入成功
 */
- (void)insertPackages:(NSArray<Package *> * _Nonnull)packages
        withCompletion:(_Nullable AlterCompletion)completion;

/**
 *  删除单条手机安装的应用的数据
 *
 *  @param package    要删除的应用
 *  @param completion 完成时的回调，可能为空
 *
 *  TODO : 判断是否删除成功
 */
- (void)deletePackage:(Package * _Nonnull)package
       withCompletion:(_Nullable AlterCompletion)completion;

/**
 *  删除多条手机安装的应用的数据
 *
 *  @param packages    要删除的应用
 *  @param completion  完成时的回调，可能为空
 *
 *  TODO : 判断是否删除成功
 */
- (void)deletePackages:(NSArray<Package *> * _Nonnull)packages
        withCompletion:(_Nullable AlterCompletion)completion;
@end
