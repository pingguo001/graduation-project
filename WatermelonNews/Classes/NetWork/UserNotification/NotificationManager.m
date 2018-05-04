//
//  NotificationManager.m
//  Hades
//
//  Created by 张子琦 on 28/03/2017.
//  Copyright © 2017 lyq. All rights reserved.
//

#import "NotificationManager.h"
#import "UserNotification.h"
#import "FetchNotificationApi.h"

typedef void(^FetchCompletionHandler)(void);

@interface NotificationManager () <ResponseDelegate>
@property (nonatomic, strong) FetchCompletionHandler fetchCompletionHandler;
@end

@implementation NotificationManager

/**
 获取单例

 @return 单例对象
 */
+ (instancetype)sharedInstance {
    static NotificationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NotificationManager new];
    });
    return manager;
}

/**
 检查通知授权
 */
+ (void)checkNotificationAuthorization {
    [UserNotification requestNotificationWithCompletionHandler:^(BOOL result) {
        if (!result) {
            [UserNotification showEnableUserNotificationTipAlert];
        }
    }];
}

/**
 拉取通知
 */
- (void)fetchNotifications {
    FetchNotificationApi *api = [FetchNotificationApi new];
    [api setDelegate:self];
    [api call];
}

/**
 拉取通知，并获取拉取完毕的回调

 @param completionHandler 拉取完毕后的回调
 */
- (void)fetchNotificationsWithCompletionHandler:(void(^)(void))completionHandler {
    FetchNotificationApi *api = [FetchNotificationApi new];
    [api setDelegate:self];
    [api call];
    [self setFetchCompletionHandler:completionHandler];
}

/**
 批量发送通知
 
 @param params 参数
 */
- (void)notificationsWithParams:(NSArray *)params {
    for (id param in params) {
        if (![param isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        [self notificationWithParam:param];
    }
}

/**
 发送通知

 @param param 参数
 */
- (void)notificationWithParam:(NSDictionary *)param {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[param[@"fire_date"] intValue]];
    
    [UserNotification scheduleNotificationWithIdentifier:param[@"identifier"]
                                                   title:param[@"title"]
                                                    body:param[@"body"]
                                                    date:date];
}

- (void)request:(NetworkRequest *)request success:(id)response {
    if (![response isKindOfClass:[NSArray class]] ||
        [response count] == 0) {
        return;
    }
    [self notificationsWithParams:response];
    if (_fetchCompletionHandler) {
        _fetchCompletionHandler();
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    if (_fetchCompletionHandler) {
        _fetchCompletionHandler();
    }
}

@end
