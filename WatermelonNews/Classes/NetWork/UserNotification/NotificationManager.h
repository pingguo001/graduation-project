//
//  NotificationManager.h
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

/**
 获取单例
 
 @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 检查通知授权
 */
+ (void)checkNotificationAuthorization;

/**
 拉取通知
 */
- (void)fetchNotifications;

/**
 拉取通知，并获取拉取完毕的回调
 
 @param completionHandler 拉取完毕后的回调
 */
- (void)fetchNotificationsWithCompletionHandler:(void(^)(void))completionHandler;

@end
