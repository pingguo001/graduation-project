//
//  JPushApi.h
//  DaodaoMusic
//
//  Created by Zhangziqi on 9/21/16.
//  Copyright © 2016 Daodao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

@interface JPushApi : NSObject

/**
 初始化，并且获取实例，在 application:didFinishLaunchingWithOptions: 中调用
 
 @param options 初始化参数
 
 @return 实例对象
 */
+ (nonnull instancetype)apiWithOptions:(nullable NSDictionary *)options;

/**
 注册DeviceToken
 
 @param deviceToken 从苹果服务器拿到的Device Token
 */
+ (void)registerDeviceToken:(nonnull NSData *)deviceToken;

/**
 注册Alias
 
 @param alias 通常是一个字符串
 */
+ (void)registerAlias:(nonnull NSString *)alias;

/**
 处理收到的通知消息，在 application:didReceiveRemoteNotification:fetchCompletionHandler: 中调用
 
 @param notification      收到的消息
 @param completionHandler 完成的处理
 */
+ (void)executeRemoteNotification:(nonnull NSDictionary *)notification
       withFetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler;

/**
 清除应用程序图标的Badge
 */
+ (void)clearBadge;
@end
