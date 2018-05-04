//
//  QQShareApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "QQShareApi.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define QQ_APP_ID @"qq957d8182d982bcd6"

@interface QQShareApi ()<TencentSessionDelegate>

@property (strong, nonatomic) TencentOAuth *tencentOAuth;

@end

@implementation QQShareApi

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QQShareApi *instance;
    dispatch_once(&onceToken, ^{

        instance = [QQShareApi new];

    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APP_ID andDelegate:self];
    }
    return self;
}

- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(QQScene)scene
{
    //分享跳转URL
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:articleModel.url] title:articleModel.title description:articleModel.source previewImageURL:[NSURL URLWithString:articleModel.cover.firstObject]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (scene == QQSceneQFriend) {
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    } else if (scene == QQSceneQZone){
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    }
}

/**
 *  处理QQ分享的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url
{
    [TencentOAuth HandleOpenURL:url];
}

- (void)addShareResponse:(APIResponse *)response
{
    
}



@end
