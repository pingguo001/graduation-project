//
//  Package.h
//  Kratos
//
//  Created by Zhangziqi on 3/28/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Package : NSObject

@property(nonatomic, copy) NSString *bundleId; /**< App 的 Bundle Id，e.g. com.apple.safari */
@property(nonatomic, copy) NSString *bundleExecutable; /**< App 的 Bundle Executable，e.g. Safari */
@property(nonatomic) BOOL isPlaceholder; /**< App 是否是安装状态 */

/**
 *  工厂初始化方法
 *
 *  @param proxy Proxy
 *
 *  @return Package 对象
 */
+ (instancetype)initWithProxy:(id)proxy;

/**
 *  工厂初始化方法
 *
 *  @param bundleId      应用Bundle Id
 *  @param bundleExecutable 应用名称
 *
 *  @return Package 对象
 */
+ (instancetype)initWithBundleId:(NSString *)bundleId
                bundleExecutable:(NSString *)bundleExecutable;

/**
 *  工厂初始化方法
 *
 *  @param dic NSDictionary对象，e.g. @{@"bundle_id":@"com.apple.safari", @"localized_name",@"Safari"}
 *
 *  @return Package 对象
 */
+ (instancetype)initWithDictionary:(NSDictionary *)dic;

/**
 *  初始化方法
 *
 *  @return Package 对象
 */
- (instancetype)init;
@end
