//
//  PackageManager.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/6.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "PackageManager.h"
#import "PackageProvider.h"
#import "UploadPackageListApi.h"
#import "NetworkErrorDefine.h"
#import "Package.h"
#import <objc/runtime.h>
#import "UserManager.h"
#import "TaskListApi.h"
#import "ProcessManager.h"

@interface PackageManager () <ResponseDelegate>
@property(nonatomic, strong) UploadPackageListApi *api;             /**< 调用上传的API */
@property (strong, nonatomic) TaskListApi *taskListApi;
@property(nonatomic)         BOOL                 hasFullUpload;    /**< 是否已经上传全量安装包 */
@end

@implementation PackageManager

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype)init {
    if (self = [super init]) {
        [self prepare];
        _api = [[UploadPackageListApi alloc] init];
        _api.delegate = self;
        _hasFullUpload = NO;
        
        _taskListApi = [[TaskListApi alloc] init];
        _taskListApi.delegate = self;
        
    }
    return self;
}

/**
 *  上传本地安装的APP
 */
- (void)uploadDevicePackage {
    if (@available(iOS 11.0, *)) {
        
        [_taskListApi call];  //获取任务列表
        
    } else {
        
        if (_hasFullUpload) {
            [PackageProvider incrementalPackagesWithCompletion:^(NSArray<Package *> * _Nonnull result) {
                if (result.count != 0) {
                    [_api setParams:@{@"packages" : [result valueForKeyPath:@"bundleId"],
                                      @"channel" : APPLICATIONCHANNEL}];
                    [_api call];
                }
            }];
        } else {
            _hasFullUpload = YES;
            [PackageProvider fullPackagesWithCompletion:^(NSArray<Package *> * _Nonnull result) {
                [_api setParams:@{@"packages" : [result valueForKeyPath:@"bundleId"],
                                  @"channel" : APPLICATIONCHANNEL}];
                [_api call];
            }];
        }
    }
    
}

/**
 *  判断App是否安装
 *
 *  @param bundleId App的BundleId
 *
 *  @return 是否安装
 */
+ (BOOL)isAppInstalled:(NSString *_Nonnull)bundleId {
    
    if (bundleId == nil) {
        return NO;
    }
    //iOS 11 判断APP是否安装
    if (@available(iOS 11.0, *)) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithJSON:[UserManager currentUser].unblock];
        
        NSString *selectorStr = dic[@"container_sel"];
        SEL sel = NSSelectorFromString(selectorStr);
        
        NSBundle *container = [NSBundle bundleWithPath:dic[@"framework"]];
        if ([container load]) {
            Class appContainer = NSClassFromString(dic[@"container"]);
            
            id test = [appContainer performSelector:sel withObject:bundleId withObject:nil];
            WNLog(@"%@",test);
            if (test) {
                return YES;
            } else {
                return NO;
            }
        }
        return NO;
    } else {
        
        NSArray *localApps = [PackageProvider localPackages];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bundleId == %@", bundleId];
        NSArray *targetApps = [localApps filteredArrayUsingPredicate:predicate];
        if (targetApps.count > 0) {
            for (Package *targetApp in targetApps) {
                return !targetApp.isPlaceholder;
            }
        }
        return NO;
        
    }
}

/**
 *  打开App
 *
 *  @param bundleId App的BundleId
 */
+ (BOOL)openApp:(NSString *_Nonnull)bundleId {
    
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:[UserManager currentUser].unblock];
    NSString *str = dic[@"workspace"];
    
    NSString *selectorStr = dic[@"default"];
    SEL sel = NSSelectorFromString(selectorStr);
    
    NSString *openStr = dic[@"open"];
    SEL openSel = NSSelectorFromString(openStr);
    
    Class class_workspace = objc_getClass([str cStringUsingEncoding:NSASCIIStringEncoding]);
    
    NSObject* workspace = [class_workspace performSelector:sel];
    return [workspace performSelector:openSel withObject:bundleId];
}

/**
 *  第一次初始化时本地把已经安装的所有应用写入数据库，因为查询进程时会用到
 */
- (void)prepare {
    [PackageProvider fullPackagesWithCompletion:^(NSArray<Package *> * _Nonnull result) {
        
    }];
}

/**
 iOS 11 以上系统无法获取本地安装的APP列表，暂时这么处理
 判断列表中的任务本地是否已经安装了，若已安装，上传包名给服务器，相当于已经做过这个任务了，下次任务列表不会再返回
 @param response 获得的任务列表
 */
- (void)handleDidTaskList:(id)response
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *uploadArray = [NSMutableArray array];
        [response enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([PackageManager isAppInstalled:obj[@"bundle_id"]]) {
                
                [uploadArray addObject:obj[@"bundle_id"]];
                WNLog(@"安装的任务：--%@", obj[@"app_name"]);
            }
        }];
        if (uploadArray.count != 0) {
            [_api setParams:@{@"packages" : uploadArray,
                              @"channel" : APPLICATIONCHANNEL}];
            [_api call];
        }
    });
    
}

#pragma -
#pragma ResponseDelegate Protocol Implementation

/**
 *  上传请求成功时的回调
 *
 *  @param request  原始请求
 *  @param response 返回值
 */
- (void)request:(NetworkRequest *)request success:(id)response {
    // nothing to do
    if ([request.url containsString:taskListUrl]) {
        
        [self handleDidTaskList:response];
    }
}

/**
 *  上传请求失败时的回调
 *
 *  @param request 原始请求
 *  @param error   错误信息
 */
- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    if (_resolver != nil) {
        [_resolver resolveError:error ofRequest:request];
    }
}


@end
