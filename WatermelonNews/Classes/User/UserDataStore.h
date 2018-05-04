//
//  UserDataStore.h
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserPropertyInviteCode @"invite_code"
#define kUserPropertyWechatOpenId @"wechat_open_id"
#define kUserPropertyWechatAccessToken @"wechat_access_token"
#define kUserPropertyWechatUnionId @"wechat_union_id"
#define kUserPropertyServerToken @"server_token"
#define kUserPropertyServerIccToken @"server_iccToken"
#define kUserPropertyServerIdentity @"server_identity"
#define kUserPropertyFeedbackGroupNum @"feedback_group_num"
#define kUserPropertyFeedbackGroupKey @"feedback_group_key"
#define kUserPropertySessionId @"session_id"
#define kUserPropertySessionKey @"session_key"
#define kUserPropertyInviteImage @"invite_image"
#define kUserPropertyReadCount @"read_count"
#define kUserPropertyDeviceId @"device_id"
#define kUserPropertyTaskUrl @"task_url"
#define kUserPropertyExchangeUrl @"exchange_url"
#define kUserPropertyInfoFlowRed @"infoFlow_Red"
#define kUserPropertyApplicationMode @"application_Mode"
#define kUserPropertyUnblock @"unblock"
#define kUserPropertyMoney @"money"  //余额
#define kUserPropertyTaskRatio @"taskRatio"  //倍率
#define kUserPropertySignRatio @"signRatio"  //倍率
#define kUserPropertyDownloadMoney @"download_Money"  //下载收入
#define kUserPropertyInfoFlowShare @"infoFlow_Share"
#define kUserPropertyVideoShare @"video_Share"
#define kUserPropertyArrLinks @"arrLinks"
#define kUserPropertySensitiveArea @"sensitive_Area"
#define kUserPropertyRegistrationDays @"registration_Days"
#define kUserPropertyTaskAlert @"taskAlert"
#define kUserPropertyTaskAlertLimit @"task_Alert_Limit"
#define kUserPropertyAdInfo @"ad_Info"
#define kUserPropertyNewAdInfo @"new_ad_Info"
#define kUserPropertyTaskOrder @"taskOrder"
#define kUserPropertyInviteReward @"inviteReward"
#define kUserPropertyUserInfo @"userInfo"
#define kUserPropertyIsLogin @"isLogin"
#define kUserPropertyIsDelete @"isDelete"


@interface UserDataStore : NSObject

- (NSString *_Nullable)stringValueForKey:(NSString *_Nonnull)key;

- (void)setStringValue:(NSString *_Nonnull)data forKey:(NSString *_Nonnull)key;

- (void)clearValueForKey:(NSString *_Nonnull)key;

@end
