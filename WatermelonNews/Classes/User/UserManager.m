//
//  UserManager.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/1.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "UserManager.h"
#import "UserDataStore.h"

@interface UserManager()
@property(nonatomic, strong) UserDataStore *store;
@end

@implementation UserManager

+ (UserManager *_Nonnull)currentUser {
    static UserManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[UserManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [[UserDataStore alloc] init];
    }
    return self;
}

- (NSString *_Nonnull)inviteCode
{
    return [_store stringValueForKey:kUserPropertyInviteCode];

}

- (void)setInviteCode:(NSString *_Nonnull)inviteCode
{
    [_store setStringValue:inviteCode forKey:kUserPropertyInviteCode];

}

- (NSString *_Nonnull)account {
    return [_store stringValueForKey:kUserPropertyWechatOpenId];
}

- (void)setAccount:(NSString *_Nonnull)account {
    [_store setStringValue:account forKey:kUserPropertyWechatOpenId];
}

- (void)clearAccount {
    [_store clearValueForKey:kUserPropertyWechatOpenId];
}

- (NSString *_Nonnull)password {
    return [_store stringValueForKey:kUserPropertyWechatAccessToken];
}

- (void)setPassword:(NSString *_Nonnull)password {
    [_store setStringValue:password forKey:kUserPropertyWechatAccessToken];
}

- (void)clearPassword {
    [_store clearValueForKey:kUserPropertyWechatAccessToken];
}

- (NSString *_Nonnull)unionId {
    return [_store stringValueForKey:kUserPropertyWechatUnionId];
}

- (void)setUnionId:(NSString *_Nonnull)unionId {
    [_store setStringValue:unionId forKey:kUserPropertyWechatUnionId];
}

- (void)clearUnionId {
    [_store clearValueForKey:kUserPropertyWechatUnionId];
}

- (NSString *_Nonnull)token {
    return [_store stringValueForKey:kUserPropertyServerToken];
}

- (void)setToken:(NSString *_Nonnull)token {
    [_store setStringValue:token forKey:kUserPropertyServerToken];
}

- (NSString *_Nonnull)iccToken
{
    return [_store stringValueForKey:kUserPropertyServerIccToken];
}

- (void)setIccToken:(NSString *_Nonnull)iccToken
{
    [_store setStringValue:iccToken forKey:kUserPropertyServerIccToken];

}

- (void)clearToken {
    [_store clearValueForKey:kUserPropertyServerToken];
}

- (NSString *_Nonnull)identity {
   return [_store stringValueForKey:kUserPropertyServerIdentity];
}

- (void)setIdentity:(NSString *_Nonnull)identity {
    [_store setStringValue:identity forKey:kUserPropertyServerIdentity];
}

- (void)clearIdentity {
    [_store clearValueForKey:kUserPropertyServerIdentity];
}

- (NSString *_Nullable)feedbackGroupNum {
    return [_store stringValueForKey:kUserPropertyFeedbackGroupNum];
}

- (void)setFeedbackGroupNum:(NSString *_Nonnull)feedbackGroupNum {
    [_store setStringValue:feedbackGroupNum forKey:kUserPropertyFeedbackGroupNum];
}

- (NSString *_Nullable)feedbackGroupKey {
    return [_store stringValueForKey:kUserPropertyFeedbackGroupKey];
}

- (void)setFeedbackGroupKey:(NSString *_Nonnull)feedbackGroupKey {
    [_store setStringValue:feedbackGroupKey forKey:kUserPropertyFeedbackGroupNum];
}

- (NSString *_Nullable)inviteImage {
    return [_store stringValueForKey:kUserPropertyInviteImage];
}

- (void)setInviteImage:(NSString *_Nonnull)inviteImage {
    [_store setStringValue:inviteImage forKey:kUserPropertyInviteImage];
}

- (NSString *_Nullable)readCount
{
    return [_store stringValueForKey:kUserPropertyReadCount];
}

- (void)setReadCount:(NSString *_Nonnull)readCount
{
    [_store setStringValue:readCount forKey:kUserPropertyReadCount];
}

- (NSString *_Nullable)deviceId
{
    return [_store stringValueForKey:kUserPropertyDeviceId];
}

- (void)setDeviceId:(NSString *_Nonnull)deviceId
{
    [_store setStringValue:deviceId forKey:kUserPropertyDeviceId];
}

- (NSString *_Nullable)taskUrl
{
    return [_store stringValueForKey:kUserPropertyTaskUrl];
}

- (void)setTaskUrl:(NSString *_Nonnull)taskUrl
{
    [_store setStringValue:taskUrl forKey:kUserPropertyTaskUrl];
}

- (NSString *_Nullable)exchangeUrl
{
    return [_store stringValueForKey:kUserPropertyExchangeUrl];
}

- (void)setExchangeUrl:(NSString *_Nonnull)exchangeUrl
{
    [_store setStringValue:exchangeUrl forKey:kUserPropertyExchangeUrl];
}

- (NSString *_Nullable)infoFlowRed
{
    return [_store stringValueForKey:kUserPropertyInfoFlowRed];
}

- (void)setInfoFlowRed:(NSString *_Nonnull)infoFlowRed
{
    [_store setStringValue:infoFlowRed forKey:kUserPropertyInfoFlowRed];
}

- (NSString *_Nullable)applicationMode
{
    return [_store stringValueForKey:kUserPropertyApplicationMode];
}

- (void)setApplicationMode:(NSString *_Nonnull)applicationMode
{
    [_store setStringValue:applicationMode forKey:kUserPropertyApplicationMode];
}

- (NSString *_Nullable)unblock
{
    return [_store stringValueForKey:kUserPropertyUnblock];
}

- (void)setUnblock:(NSString *_Nonnull)unblock
{
    [_store setStringValue:unblock forKey:kUserPropertyUnblock];
}

- (NSString *_Nullable)money
{
    return [_store stringValueForKey:kUserPropertyMoney];
}

- (void)setMoney:(NSString *_Nonnull)money
{
    [_store setStringValue:money forKey:kUserPropertyMoney];
}

- (NSString *_Nullable)taskRatio
{
    return [_store stringValueForKey:kUserPropertyTaskRatio];
}

- (void)setTaskRatio:(NSString *_Nonnull)taskRatio
{
    [_store setStringValue:taskRatio forKey:kUserPropertyTaskRatio];
}

- (NSString *_Nullable)signRatio
{
    return [_store stringValueForKey:kUserPropertySignRatio];
}

- (void)setSignRatio:(NSString *_Nonnull)signRatio
{
    [_store setStringValue:signRatio forKey:kUserPropertySignRatio];
}

- (NSString *_Nullable)downloadMoney
{
    return [_store stringValueForKey:kUserPropertyDownloadMoney];
}

- (void)setDownloadMoney:(NSString *_Nonnull)downloadMoney
{
    [_store setStringValue:downloadMoney forKey:kUserPropertyDownloadMoney];
}

- (NSString *_Nullable)infoFlowShare
{
    return [_store stringValueForKey:kUserPropertyInfoFlowShare];
}

- (void)setInfoFlowShare:(NSString *_Nonnull)infoFlowShare
{
    [_store setStringValue:infoFlowShare forKey:kUserPropertyInfoFlowShare];
}

- (NSString *_Nullable)videoShare
{
    return [_store stringValueForKey:kUserPropertyVideoShare];
}

- (void)setVideoShare:(NSString *_Nonnull)videoShare
{
    [_store setStringValue:videoShare forKey:kUserPropertyVideoShare];
}
- (NSString *_Nullable)arrLinks
{
    return [_store stringValueForKey:kUserPropertyArrLinks];
}

- (void)setArrLinks:(NSString *_Nonnull)arrLinks
{
    [_store setStringValue:arrLinks forKey:kUserPropertyArrLinks];
}

- (NSString *_Nullable)sensitiveArea
{
    return [_store stringValueForKey:kUserPropertySensitiveArea];
}

- (void)setSensitiveArea:(NSString *_Nonnull)sensitiveArea
{
    [_store setStringValue:sensitiveArea forKey:kUserPropertySensitiveArea];
}

- (NSString *_Nullable)registrationDays
{
    return [_store stringValueForKey:kUserPropertyRegistrationDays];
}

- (void)setRegistrationDays:(NSString *_Nonnull)registrationDays
{
    [_store setStringValue:registrationDays forKey:kUserPropertyRegistrationDays];
}

- (NSString *_Nullable)taskAlert
{
    return [_store stringValueForKey:kUserPropertyTaskAlert];
}

- (void)setTaskAlert:(NSString *_Nonnull)taskAlert
{
    [_store setStringValue:taskAlert forKey:kUserPropertyTaskAlert];
}

- (NSString *_Nullable)taskAlertLimit
{
    return [_store stringValueForKey:kUserPropertyTaskAlertLimit];
}

- (void)setTaskAlertLimit:(NSString *_Nonnull)taskAlertLimit
{
    [_store setStringValue:taskAlertLimit forKey:kUserPropertyTaskAlertLimit];
}

- (NSString *_Nullable)adInfo
{
    return [_store stringValueForKey:kUserPropertyAdInfo];
}

- (void)setAdInfo:(NSString *_Nonnull)adInfo
{
    [_store setStringValue:adInfo forKey:kUserPropertyAdInfo];
}

- (NSString *_Nullable)newAdInfo
{
    return [_store stringValueForKey:kUserPropertyNewAdInfo];
}

- (void)setNewAdInfo:(NSString *_Nonnull)newAdInfo
{
    [_store setStringValue:newAdInfo forKey:kUserPropertyNewAdInfo];
}

- (NSString *_Nullable)taskOrder
{
    return [_store stringValueForKey:kUserPropertyTaskOrder];
}

- (void)setTaskOrder:(NSString *_Nonnull)taskOrder
{
    [_store setStringValue:taskOrder forKey:kUserPropertyTaskOrder];
}

- (NSString *_Nullable)inviteReward
{
    return [_store stringValueForKey:kUserPropertyInviteReward];
}

- (void)setInviteReward:(NSString *_Nonnull)inviteReward
{
    [_store setStringValue:inviteReward forKey:kUserPropertyInviteReward];
}

- (NSString *_Nullable)userInfo
{
    return [_store stringValueForKey:kUserPropertyUserInfo];
}

- (void)setUserInfo:(NSString *_Nonnull)userInfo
{
    [_store setStringValue:userInfo forKey:kUserPropertyUserInfo];
}

- (NSString *_Nullable)isLogin
{
    return [_store stringValueForKey:kUserPropertyIsLogin];
}

- (void)setIsLogin:(NSString *_Nonnull)isLogin
{
    [_store setStringValue:isLogin forKey:kUserPropertyIsLogin];
}

- (NSString *_Nullable)isDelete
{
    return [_store stringValueForKey:kUserPropertyIsDelete];
}

- (void)setIsDelete:(NSString *_Nonnull)isDelete
{
    [_store setStringValue:isDelete forKey:kUserPropertyIsDelete];
}

@end
