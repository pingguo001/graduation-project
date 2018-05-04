//
//  RongCloudManager.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/5.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "RongCloudManager.h"
//正式
#define  RYKey        @"y745wfm8y7vtv"

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "HttpRequest.h"

@implementation RongCloudManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static RongCloudManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [RongCloudManager new];
    });
    return manager;
}

- (void)loginRongCloud
{
    if ([UserManager currentUser].isLogin.integerValue == 0) {
        return;
    }
    [[RCIMClient sharedRCIMClient] initWithAppKey:RYKey];
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    UserModel *model = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
    
    [HttpRequest rongCloudPost:@"http://api.cn.ronghub.com/user/getToken.json"
                        params:@{
                                 @"userId" : [UserManager currentUser].deviceId,
                                 @"name" : model.nickName,
                                 @"portraitUri" : model.avatar
                                 
                                 } success:^(id responseObj) {
                                     
                                     //  连接融云
                                     [[RCIM sharedRCIM] connectWithToken:responseObj[@"token"] success:^(NSString *userId) {
                                         NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                         
                                         UserModel *model = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
                                         
                                         RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                                         userInfo.userId = userId;
                                         userInfo.name = model.nickName;
                                         userInfo.portraitUri = model.avatar;
                                         
                                         [RCIM sharedRCIM].currentUserInfo = userInfo;
                                         [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
                                         
                                     } error:^(RCConnectErrorCode status) {
                                         NSLog(@"登陆的错误码为:%ld", (long)status);
                                     } tokenIncorrect:^{
                                         
                                     }];
                                     
                                 } failure:^(NSError *error) {
                                     
                                 }];
}

@end
