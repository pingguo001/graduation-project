//
//  PackageProvider.m
//  Kratos
//
//  Created by Zhangziqi on 3/28/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "PackageProvider.h"
#import "PackageScanner.h"
#import "Package.h"
#import "DatabaseManager.h"

static NSMutableDictionary<NSString *, Package *> *packageCache;

/**< 保存应用信息的缓存，key是应用名称，value是Package对象 */

@implementation PackageProvider

+ (void)incrementalPackagesWithCompletion:(_Nonnull Completion)completion {

    // 从数据库获取所有App，再从本地获取当前安装的所有App，
    // 两者做差集后获得新安装的App和卸载的App，
    // 把卸载的App从本地数据库删除，返回新安装的App

    [PackageProvider fullPackagesWithCompletion:^(NSArray<Package *> *_Nonnull savedPackages) {

        // 当前本地安装的所有App
        NSArray<Package *> *localPackages = [PackageProvider localPackages];

        // 新安装的App
        NSArray<Package *> *addtionalPackages = [PackageProvider pickAddtionalPackages:localPackages
                                                                     withSavedPackages:savedPackages];
        
        // 过滤掉安装中的应用
        addtionalPackages = [PackageProvider filterInstallingPackages:addtionalPackages];
        
        // 新安装的应用保存到缓存里面，避免之后要去数据库查询
        [PackageProvider savePackagesToCache:addtionalPackages];

        // 卸载的App
        NSArray<Package *> *deletedPackages = [PackageProvider pickDeletedPackages:localPackages
                                                                 withSavedPackages:savedPackages];

        [[DatabaseManager sharedInstance] deletePackages:deletedPackages withCompletion:nil];
        [[DatabaseManager sharedInstance] insertPackages:addtionalPackages withCompletion:nil];

        completion(addtionalPackages);
    }];
}

/**
 *  从数据库获取本地安装的所有App，不一定时时更新
 *
 *  @param completion 获取完成时的回调
 */
+ (void)fullPackagesWithCompletion:(_Nonnull Completion)completion {
    [[DatabaseManager sharedInstance] selectPackagesWithCompletion:^(NSArray<Package *> *_Nonnull result) {
        // 如果是空，说明是一个新设备，没有保存过
        if ([result count] == 0) {
            NSArray<Package *> *localPackages = [PackageProvider localPackages];
            [[DatabaseManager sharedInstance] insertPackages:localPackages
                                              withCompletion:^(BOOL isSuccess) {
                                                  completion(localPackages);
                                              }];
        } else {
            completion(result);
        }
    }];
}

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
                           withCompletion:(void (^ _Nonnull)(NSArray<Package *> *_Nullable))completion {
    NSArray<Package *> *result = [PackageProvider findPackagesInCacheWithBundleExecutables:bundleExecutables];
    if (result.count == bundleExecutables.count) {
        completion(result);
    } else {
        [PackageProvider findPackageInDatabaseWithBundleExecutables:bundleExecutables
                                                         completion:^(NSArray *packages) {
                                                            [PackageProvider savePackagesToCache:packages
                                                                           withBundleExecutables:bundleExecutables];
                                                            completion(packages);
                                                        }];
    }
}

/**
 *  在缓存中根据多个应用的bundle executable查找这些包的信息
 *
 *  @param bundleExecutables 要查询的包的bundle executable数组
 *
 *  @return Package对象数组，包含了这些应用相关的信息
 */
+ (NSArray<Package *> *_Nonnull)findPackagesInCacheWithBundleExecutables:(NSArray<NSString *> *_Nonnull)bundleExecutables {
    NSMutableArray *packages = [NSMutableArray arrayWithCapacity:bundleExecutables.count];
    for (NSString *bundleExecutable in bundleExecutables) {
        Package *package = [self findPackageInCacheWithBundleExecutable:bundleExecutable];
        if (package == nil) {
            continue;
        }
        [packages addObject:package];
    }
    return packages;
}

/**
 *  在缓存中根据应用的bundle executable查找这个包的信息
 *
 *  @param bundle executable 要查询的包的bundle executable
 *
 *  @return Package对象，包含了这个应用相关的信息
 */
+ (Package *_Nullable)findPackageInCacheWithBundleExecutable:(NSString *)bundleExecutable {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        packageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
    });
    return packageCache[bundleExecutable];
}

/**
 *  在数据库中根据应用的bundle executable查找这个包的信息
 *
 *  @param bundle executable  要查询的包的bundle executable数组
 *  @param completion 查询完毕后的回调
 */
+ (void)findPackageInDatabaseWithBundleExecutables:(NSArray<NSString *> *)bundleExecutables
                                        completion:(_Nonnull Completion)completion {
    [[DatabaseManager sharedInstance] selectPackagesWithBundleExecutables:bundleExecutables
                                                               completion:^(NSArray<Package *> *_Nonnull packages) {
                                                                   completion(packages);
                                                               }];
}

/**
 *  把Package信息保存到缓存里面
 *
 *  @param packages          Package 数组
 *  @param bundleExecutables Bundle Executable 数组
 */
+ (void)savePackagesToCache:(NSArray<Package *> *)packages
      withBundleExecutables:(NSArray<NSString *> *)bundleExecutables {
    for (NSUInteger index = 0; index < packages.count; ++index) {
        packageCache[packages[index].bundleExecutable] = packages[index];
    }
}

/**
 *  把Package信息保存到缓存里面
 *
 *  @param packages          Package 数组
 */
+ (void)savePackagesToCache:(NSArray<Package *> *)packages {
    for (NSUInteger index = 0; index < packages.count; ++index) {
        packageCache[packages[index].bundleExecutable] = packages[index];
    }
}

/**
 *  把应用信息保存到缓存中，并以应用的bundle executable作为索引
 *
 *  @param package   应用的信息
 *  @param bundleExecutable 应用的bundle executable
 */
+ (void)savePackageToCache:(Package *)package withBundleExecutable:(NSString *)bundleExecutable {
    packageCache[bundleExecutable] = package;
}

/**
 *  过滤掉安装中的应用，应用处于安装中时拿不到bundleExecutable
 *
 *  @param packages 要过滤的应用数组
 *
 *  @return 过滤后的数组
 */
+ (NSArray<Package *> *_Nullable)filterInstallingPackages:(NSArray<Package *> *_Nullable)packages {
    if (packages == nil) {
        return nil;
    }
    NSMutableArray *result = [packages mutableCopy];
    for (Package *package in packages) {
        if (package.bundleExecutable == nil) {
            [result removeObject:package];
        }
    }
    return [result copy];
}

/**
 *  获取当前安装的所有App
 *
 *  @return App集合
 */
+ (NSArray<Package *> *)localPackages {
    return [PackageProvider convertProxiesToPackages:[[PackageScanner sharedInstance] scan]];
}

/**
 *  转换Proxy为Package
 *
 *  @param proxies 待转换的Proxy数组
 *
 *  @return 转换完成的Package数组
 */
+ (NSArray<Package *> *)convertProxiesToPackages:(NSArray *)proxies {
    NSMutableArray *packages = [NSMutableArray arrayWithCapacity:[proxies count]];
    for (id proxy in proxies) {
        [packages addObject:[Package initWithProxy:proxy]];
    }
    return [packages copy];
}

/**
 *  转换Proxy为Package
 *
 *  @param proxy 待转换的Proxy
 *
 *  @return 转换完成的Package数组
 */
+ (Package *)convertProxyToPackage:(id)proxy {
    return [Package initWithProxy:proxy];
}

/**
 *  根据当前安装的App和本地保存的App，获得新安装的App
 *
 *  @param currentPackages 当前安装的App数组
 *  @param savedPackages   本地保存的App数组
 *
 *  @return 新安装的App数组
 */
+ (NSArray<Package *> *)pickAddtionalPackages:(NSArray<Package *> *)currentPackages
                            withSavedPackages:(NSArray<Package *> *)savedPackages {
    NSArray *bundleIds = [savedPackages valueForKeyPath:@"@unionOfObjects.bundleId"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF.bundleId IN %@)", bundleIds];
    return [currentPackages filteredArrayUsingPredicate:predicate];
}

/**
 *  根据当前安装的App和本地保存的App，获得已删除的App
 *
 *  @param currentPackages 当前安装的App数组
 *  @param savedPackages   本地保存的App数组
 *
 *  @return 已删除的App数组
 */
+ (NSArray<Package *> *)pickDeletedPackages:(NSArray<Package *> *)currentPackages
                          withSavedPackages:(NSArray<Package *> *)savedPackages {
    NSArray *bundleIds = [currentPackages valueForKeyPath:@"@unionOfObjects.bundleId"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF.bundleId IN %@)", bundleIds];
    return [savedPackages filteredArrayUsingPredicate:predicate];
}

@end
