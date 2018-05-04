//
//  UserManager.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/1.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager *_Nonnull)currentUser;

- (NSString *_Nonnull)inviteCode;

- (void)setInviteCode:(NSString *_Nonnull)inviteCode;

- (NSString *_Nonnull)account;

- (void)setAccount:(NSString *_Nonnull)account;

- (void)clearAccount;

- (NSString *_Nonnull)password;

- (void)setPassword:(NSString *_Nonnull)password;

- (void)clearPassword;

- (NSString *_Nonnull)unionId;

- (void)setUnionId:(NSString *_Nonnull)unionId;

- (void)clearUnionId;

- (NSString *_Nonnull)token;

- (void)setToken:(NSString *_Nonnull)token;

- (NSString *_Nonnull)iccToken;

- (void)setIccToken:(NSString *_Nonnull)iccToken;

- (void)clearToken;

- (NSString *_Nonnull)identity;

- (void)setIdentity:(NSString *_Nonnull)identity;

- (void)clearIdentity;

- (NSString *_Nullable)feedbackGroupNum;

- (void)setFeedbackGroupNum:(NSString *_Nonnull)feedbackGroupNum;

- (NSString *_Nullable)feedbackGroupKey;

- (void)setFeedbackGroupKey:(NSString *_Nonnull)feedbackGroupKey;

- (NSString *_Nullable)inviteImage;

- (void)setInviteImage:(NSString *_Nonnull)inviteImage;

- (NSString *_Nullable)readCount;

- (void)setReadCount:(NSString *_Nonnull)readCount;

- (NSString *_Nullable)deviceId;

- (void)setDeviceId:(NSString *_Nonnull)deviceId;

- (NSString *_Nullable)taskUrl;

- (void)setTaskUrl:(NSString *_Nonnull)taskUrl;

- (NSString *_Nullable)exchangeUrl;

- (void)setExchangeUrl:(NSString *_Nonnull)exchangeUrl;

- (NSString *_Nullable)infoFlowRed;

- (void)setInfoFlowRed:(NSString *_Nonnull)infoFlowRed;

- (NSString *_Nullable)applicationMode;

- (void)setApplicationMode:(NSString *_Nonnull)applicationMode;

- (NSString *_Nullable)unblock;

- (void)setUnblock:(NSString *_Nonnull)unblock;

- (NSString *_Nullable)money;

- (void)setMoney:(NSString *_Nonnull)money;

- (NSString *_Nullable)taskRatio;

- (void)setTaskRatio:(NSString *_Nonnull)taskRatio;

- (NSString *_Nullable)signRatio;

- (void)setSignRatio:(NSString *_Nonnull)signRatio;

- (NSString *_Nullable)downloadMoney;

- (void)setDownloadMoney:(NSString *_Nonnull)downloadMoney;

- (NSString *_Nullable)infoFlowShare;

- (void)setInfoFlowShare:(NSString *_Nonnull)infoFlowShare;

- (NSString *_Nullable)videoShare;

- (void)setVideoShare:(NSString *_Nonnull)videoShare;

- (NSString *_Nullable)arrLinks;

- (void)setArrLinks:(NSString *_Nonnull)arrLinks;

- (NSString *_Nullable)sensitiveArea;

- (void)setSensitiveArea:(NSString *_Nonnull)sensitiveArea;

- (NSString *_Nullable)registrationDays;

- (void)setRegistrationDays:(NSString *_Nonnull)registrationDays;

- (NSString *_Nullable)taskAlert;

- (void)setTaskAlert:(NSString *_Nonnull)taskAlert;

- (NSString *_Nullable)taskAlertLimit;

- (void)setTaskAlertLimit:(NSString *_Nonnull)taskAlertLimit;

- (NSString *_Nullable)adInfo;

- (void)setAdInfo:(NSString *_Nonnull)adInfo;

- (NSString *_Nullable)newAdInfo;

- (void)setNewAdInfo:(NSString *_Nonnull)newAdInfo;

- (NSString *_Nullable)taskOrder;

- (void)setTaskOrder:(NSString *_Nonnull)taskOrder;

- (NSString *_Nullable)inviteReward;

- (void)setInviteReward:(NSString *_Nonnull)inviteReward;

- (NSString *_Nullable)userInfo;

- (void)setUserInfo:(NSString *_Nonnull)userInfo;

- (NSString *_Nullable)isLogin;

- (void)setIsLogin:(NSString *_Nonnull)isLogin;

- (NSString *_Nullable)isDelete;

- (void)setIsDelete:(NSString *_Nonnull)isDelete;

@end
