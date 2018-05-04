//
//  JPushApi.m
//  DaodaoMusic
//
//  Created by Zhangziqi on 9/21/16.
//  Copyright © 2016 Daodao. All rights reserved.
//

#import "JPushApi.h"
#import "JPUSHService.h"
#import <AdSupport/ASIdentifierManager.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>
#import "NotificationModel.h"
#import "NewsDetailViewController.h"

#define JPUSH_APP_KEY  @"fe8f01f43b2646752a30f212"
#define JPUSH_SECRET   @"e22a2ff200e6bc034ee15c28"
#define JPUSH_CHANNE   @"APPSTORE_XIGUATOUTIAO"

#ifdef DEBUG
#define JPUSH_PRODUCTION  NO
#else
#define JPUSH_PRODUCTION  YES
#endif

@interface JPushApi () <JPUSHRegisterDelegate>

@property (strong, nonatomic) NotificationModel *currentModel;

@end

@implementation JPushApi


#pragma -
#pragma mark Initialize

/**
 初始化，并且获取实例，在 application:didFinishLaunchingWithOptions: 中调用

 @param options 初始化参数
 
 @return 实例对象
 */
+ (instancetype _Nonnull)apiWithOptions:(NSDictionary *)options {
    static JPushApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JPushApi alloc] initWithOptions:options];;
    });
    return instance;
}

/**
 初始化，获得实例

 @param options 初始化参数

 @return 实例对象
 */
- (instancetype)initWithOptions:(NSDictionary *)options {
    if (self = [super init]) {
        NSInteger notificationTypes = UNAuthorizationOptionAlert |
                                      UNAuthorizationOptionBadge |
                                      UNAuthorizationOptionSound;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            JPUSHRegisterEntity *entity = [JPUSHRegisterEntity new];
            entity.types = notificationTypes;
            [JPUSHService registerForRemoteNotificationConfig:entity
                                                     delegate:self];
        } else {
            [JPUSHService registerForRemoteNotificationTypes:notificationTypes
                                                  categories:nil];
        }
        
        NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        [JPUSHService setupWithOption:options
                               appKey:JPUSH_APP_KEY
                              channel:JPUSH_CHANNE
                     apsForProduction:JPUSH_PRODUCTION
                advertisingIdentifier:adid];
    }
    return self;
}


#pragma -
#pragma mark About Notification

/**
 注册DeviceToken

 @param deviceToken 从苹果服务器拿到的Device Token
 */
+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

/**
 注册Alias
 
 @param alias 通常是一个字符串
 */
+ (void)registerAlias:(nonnull NSString *)alias {
    
    [JPUSHService setAlias:alias completion:nil seq:alias.integerValue];
}

/**
 处理收到的通知消息，在 application:didReceiveRemoteNotification:fetchCompletionHandler: 中调用

 @param notification      收到的消息
 @param completionHandler 完成的处理
 */
+ (void)executeRemoteNotification:(NSDictionary *)notification
       withFetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:notification];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma -
#pragma mark About Badge

/**
 清除应用程序图标的Badge
 */
+ (void)clearBadge {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

#pragma -
#pragma mark JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger options))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self pushDataHandle:userInfo];
    
    completionHandler(UNNotificationPresentationOptionAlert |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionBadge);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self pushDataHandle:userInfo];
    completionHandler();
}

- (void)pushDataHandle:(NSDictionary *)userInfo
{
    NotificationModel *model = [NotificationModel mj_objectWithKeyValues:userInfo];
    self.currentModel = model;
    if ([model.type isEqualToString:@"article"]) {
    
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if (![tabBarVC isKindOfClass:[UITabBarController class]]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAction) name:@"enterMain" object:nil];
            return;
        }
        UINavigationController *currentNav = tabBarVC.selectedViewController;
        NewsDetailViewController *detailVC = [NewsDetailViewController new];
        detailVC.model = model.content;
        [currentNav showViewController:detailVC sender:nil];
    }
}

- (void)openAction
{
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *currentNav = tabBarVC.selectedViewController;
    NewsDetailViewController *detailVC = [NewsDetailViewController new];
    detailVC.model = self.currentModel.content;
    [currentNav showViewController:detailVC sender:nil];
}

@end
