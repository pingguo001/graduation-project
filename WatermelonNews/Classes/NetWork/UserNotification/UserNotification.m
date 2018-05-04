//
//  UserNotification.m
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import "UserNotification.h"
#import "UIViewController+Utils.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@implementation UserNotification

/**
 请求通知权限
 */
+ (void)requestNotificationWithCompletionHandler:(void(^)(BOOL))completionHandler {
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  completionHandler(granted);
                              }];
    } else {
        UIApplication *application = [UIApplication sharedApplication];
        NSInteger flags = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:flags categories:nil];
        [application registerUserNotificationSettings:settings];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completionHandler([application currentUserNotificationSettings].types != 0);
        });
    }
}

/**
 显示提示用户开启通知的Alert
 */
+ (void)showEnableUserNotificationTipAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert_Warm_Title", nil) message:NSLocalizedString(@"Alert_Enable_Notification_Msg", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:NSLocalizedString(@"Alert_Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Alert_Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:settings];
    [alert addAction:cancel];
    [[UIViewController currentViewController] presentViewController:alert animated:YES completion:nil];
}

/**
 立即显示一个通知

 @param identifier 通知的标识
 @param title 通知标题
 @param body 通知内容
 */
+ (void)showNotificationWithIdentifier:(NSString *)identifier
                                 Title:(NSString *)title
                                  body:(NSString *)body {
    [self scheduleNotificationWithIdentifier:identifier
                                       title:title
                                        body:body
                                        date:nil];
}

/**
 规划一个通知

 @param identifier 通知的标识
 @param title 通知标题
 @param body 通知内容
 @param date 通知触发时间
 */
+ (void)scheduleNotificationWithIdentifier:(NSString *)identifier
                                     title:(NSString *)title
                                      body:(NSString *)body
                                      date:(NSDate *)date {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10) {
        [self __scheduleNotificationWithIdentifier:identifier title:title body:body date:date];
    } else {
        [self __scheduleNotificationCompatWithIdentifier:identifier body:body date:date];
    }
}

+ (void)__scheduleNotificationWithIdentifier:(NSString *)identifier
                                       title:(NSString *)title
                                        body:(NSString *)body
                                        date:(NSDate *)date {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    [content setTitle:title];
    [content setBody:body];
    [content setSound:[UNNotificationSound defaultSound]];
    UNNotificationTrigger *trigger = nil;
    if (date) {
        NSInteger fire = [date timeIntervalSince1970];
        NSInteger now = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        NSInteger interval = 1;
        if (fire > now) {
            interval = fire - now;
        }
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
        
    }
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

+ (void)__scheduleNotificationCompatWithIdentifier:(NSString *)identifier
                                              body:(NSString *)body
                                              date:(NSDate *)date {
    UILocalNotification *notification = [UILocalNotification new];
    
    notification.fireDate = date;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 0;//0表示不重复
    // 通知内容
    notification.alertBody = body;
    // 角标
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    //通知参数
    notification.userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
