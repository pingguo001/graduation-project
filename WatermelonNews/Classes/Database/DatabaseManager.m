//
//  DatabaseManager.m
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "DatabaseManager.h"
#import "EZFMDB.h"
#import "SQLDefine.h"
#import "Package.h"

#define DB_NAME @"data.db" /**< 数据库名 */
#define DB_PATH [PATH_DOCUMENT_DIR stringByAppendingPathComponent:DB_NAME] /**< 数据库保存位置 */

@interface DatabaseManager ()
@property(nonatomic, strong, nonnull) EZDatabaseQueue *database;
@end

@implementation DatabaseManager

#pragma -
#pragma initialize

/**
 *  单例方法
 *
 *  @return DatabaseManager实例
 */
+ (instancetype)sharedInstance {
    static DatabaseManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DatabaseManager alloc] init];
    });
    return instance;
}

/**
 *  初始化
 *
 *  @return DatabaseManager实例
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareDatabase];
    }
    return self;
}

/**
 *  创建数据库表，packages表用来保存全量的本地安装的应用列表
 */
- (void)prepareDatabase {
    self.database = [EZFMDB instanceWithPath:DB_PATH];
    [self.database inDatabaseRunOnMainThread:^(FMDatabase *db) {
        [self.database inDatabase:^(FMDatabase *db) {
            [db executeUpdate:SQL_CREATE_TABLE_PACKAGES];
        }];
    }];
}

#pragma -
#pragma operations

/**
 *  取出全量本地安装应用列表
 *
 *  @param complation 成功时的回调
 */
- (void)selectPackagesWithCompletion:(QueryCompletion)completion {
    [self.database inDatabase:^(FMDatabase *db) {
        [db selectWithCallback:^(NSArray<NSDictionary *> *result) {
            NSMutableArray *output = [NSMutableArray arrayWithCapacity:[result count]];
            for (NSDictionary *raw in result) {
                [output addObject:[Package initWithDictionary:raw]];
            }
            completion([output copy]);
        }              withSql:SQL_SELECT_PACKAGE_FROM_PACKAGES];
    }];
}

/**
 *  根据应用的 bundleExecutables 取出相应的应用
 *
 *  @param bundleExecutables  应用的short name，e.g. Wechat
 *  @param completion 成功时的回调
 */
- (void)selectPackagesWithBundleExecutables:(NSArray<NSString *> *_Nonnull)bundleExecutables
                                 completion:(_Nonnull QueryCompletion)completion {
    
    NSMutableString *limitation = [[bundleExecutables componentsJoinedByString:@"','"] mutableCopy];
    [limitation appendString:@"'"];
    [limitation insertString:@"'" atIndex:0];
    
    NSString *sql = [NSString stringWithFormat:SQL_SELECT_PACKAGE_BY_BUNDLE_EXECUTABLE_FROM_PACKAGES, limitation];
    
    [self.database inDatabase:^(FMDatabase *db) {
        [db selectWithCallback:^(NSArray *result) {
            NSMutableArray *output = [NSMutableArray arrayWithCapacity:[result count]];
            for (NSDictionary *raw in result) {
                [output addObject:[Package initWithDictionary:raw]];
            }
            completion([output copy]);
        }              withSql:sql];
    }];
}

/**
 *  插入单条手机安装的应用的数据
 *
 *  @param package    要插入的应用
 *  @param completion 完成时的回调，可能为空
 *
 *  TODO : 判断是否插入成功
 */
- (void)insertPackage:(nonnull Package *)package
       withCompletion:(nullable AlterCompletion)completion {
    [self insertPackages:@[package] withCompletion:completion];
}

/**
 *  插入多条手机安装的应用的数据
 *
 *  @param packages    要插入的应用
 *  @param completion  完成时的回调，可能为空
 *
 *  TODO : 判断是否插入成功
 */
- (void)insertPackages:(nonnull NSArray<Package *> *)packages
        withCompletion:(nullable AlterCompletion)completion {
    [self.database inDatabase:^(FMDatabase *db) {
        for (Package *package in packages) {
            [db executeUpdate:SQL_INSERT_PACKAGE_TO_PACKAGES, package.bundleId, package.bundleExecutable];
        }
        if (completion != nil) {
            completion(TRUE);
        }
    }];
}

/**
 *  删除单条手机安装的应用的数据
 *
 *  @param package    要删除的应用
 *  @param completion 完成时的回调，可能为空
 *
 *  TODO : 判断是否删除成功
 */
- (void)deletePackage:(nonnull Package *)package
       withCompletion:(nullable AlterCompletion)completion {
    [self deletePackages:@[package] withCompletion:completion];
}

/**
 *  删除多条手机安装的应用的数据
 *
 *  @param packages    要删除的应用
 *  @param completion  完成时的回调，可能为空
 *
 *  TODO : 判断是否删除成功
 */
- (void)deletePackages:(nonnull NSArray<Package *> *)packages
        withCompletion:(nullable AlterCompletion)completion {
    [self.database inDatabase:^(FMDatabase *db) {
        for (Package *package in packages) {
            [db executeUpdate:SQL_DELETE_PACKAGE_FROM_PACKAGES_BY_BUNDLE_ID, package.bundleId];
        }
        if (completion != nil) {
            completion(TRUE);
        }
    }];
}

@end
