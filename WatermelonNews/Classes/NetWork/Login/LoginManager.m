//
//  LoginManager.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/6.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "LoginManager.h"
#import "UserManager.h"
#import "InitLoginApi.h"
#import "ImeiLoginApi.h"
#import "LinkStartApi.h"

typedef void(^LoginSuccess)();
@interface LoginManager () <ResponseDelegate>
@property(nonatomic, strong) InitLoginApi *inLoginApi;
@property(nonatomic, strong) ImeiLoginApi *imeiLoginApi;
@property(nonatomic, strong) LinkStartApi *linkStartApi;
@property(copy, nonatomic)   LoginSuccess loginBlock;
@property(assign, nonatomic) NSInteger loginCode;

@end

@implementation LoginManager

- (instancetype)init

{
    self = [super init];
    if (self) {
        
        _inLoginApi = [[InitLoginApi alloc] initWithDelegate:self];
        _imeiLoginApi = [[ImeiLoginApi alloc] initWithDelegate:self];
        _linkStartApi = [[LinkStartApi alloc] initWithDelegate:self];
        _loginCode = 0;
        
    }
    return self;
}

- (void)login {
    
    [self serverLogin];
}

- (void)serverLogin {
    [_inLoginApi call];   //西瓜头条登录
    [_linkStartApi call]; //iCC登录
    @kWeakObj(self)
    self.loginBlock = ^ {
        if (self.loginCode == 2) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(loginSuccess:)]) {
                [selfWeak.delegate loginSuccess:nil];
            }
        }
    };
    
}

- (void)onInitLoginResponse:(NSDictionary *)response {
    [[UserManager currentUser] setToken:response[@"token"]];
    [_imeiLoginApi call];
}

- (void)onImeiLoginResponse:(NSDictionary *)response {
    
    [self saveUserInfo:response];
    self.loginCode++;
    self.loginBlock();
}

- (void)onLinkStartResponse:(NSDictionary *)response {
    
    [[UserManager currentUser] setIccToken:response[@"token"]];
    [[UserManager currentUser] setIdentity:response[@"identity"]];
    self.loginCode++;
    self.loginBlock();
}

- (void)onLoginFailure:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(loginFailure:)]) {
        [_delegate loginFailure:error];
    }
}

#pragma -
#pragma ResponseDelegate Protocol Implemetation

- (void)request:(NetworkRequest *)request success:(id)response {
    if ([request.url containsString:initLoginUrl]) {
        [self onInitLoginResponse:response];
    } else if ([request.url containsString:imeiLoginUrl]) {
        [self onImeiLoginResponse:response];
    } else if ([request.url containsString:linkStartUrl]){
        [self onLinkStartResponse:response];
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    [self onLoginFailure:error];
}


/**
 保存用户信息

 @param response <#response description#>
 */
- (void)saveUserInfo:(NSDictionary *)response
{
    [[UserManager currentUser] setReadCount:response[@"readCount"]];
    [[UserManager currentUser] setDeviceId:response[@"deviceId"]];
    [[UserManager currentUser] setTaskUrl:response[@"taskUrl"]];
    [[UserManager currentUser] setExchangeUrl:response[@"exchangeUrl"]];
    [[UserManager currentUser] setInfoFlowRed:response[@"infoFlowRed"]];
    [[UserManager currentUser] setApplicationMode:response[@"applicationMode"]];
    [[UserManager currentUser] setUnblock:[response[@"iosUnblock"] mj_JSONString]];
    [[UserManager currentUser] setAdInfo:[response[@"adInfo"] mj_JSONString]];
    [[UserManager currentUser] setNewAdInfo:[response[@"newAdInfo"] mj_JSONString]];
    [[UserManager currentUser] setMoney:response[@"money"]];
    [[UserManager currentUser] setTaskRatio:response[@"taskRatio"]];
    [[UserManager currentUser] setSignRatio:response[@"signRatio"]];
    [[UserManager currentUser] setDownloadMoney:response[@"downloadMoney"]];
    [[UserManager currentUser] setSensitiveArea:response[@"sensitiveArea"]];
    [[UserManager currentUser] setRegistrationDays:response[@"registrationDays"]];
    [[UserManager currentUser] setTaskAlert:response[@"taskAlert"]];
    [[UserManager currentUser] setTaskAlertLimit:response[@"taskAlertLimit"]];
    [[UserManager currentUser] setTaskOrder:response[@"taskOrder"]];
    [[UserManager currentUser] setInviteReward:response[@"inviteReward"]];


}

@end
