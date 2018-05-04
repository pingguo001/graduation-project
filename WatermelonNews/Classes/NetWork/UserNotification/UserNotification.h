//
//  UserNotification.h
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotification : NSObject

/**
 请求通知权限
 */
+ (void)requestNotificationWithCompletionHandler:(void(^)(BOOL))completionHandler;

/**
 显示提示用户开启通知的Alert
 */
+ (void)showEnableUserNotificationTipAlert;

/**
 立即显示一个通知
 
 @param identifier 通知的标识
 @param title 通知标题
 @param body 通知内容
 */
+ (void)showNotificationWithIdentifier:(NSString *)identifier
                                 Title:(NSString *)title
                                  body:(NSString *)body;

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
                                      date:(NSDate *)date;
@end
