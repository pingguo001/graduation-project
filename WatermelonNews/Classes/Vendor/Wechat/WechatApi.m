//
//  WechatApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "WechatApi.h"
#import "WechatAuthSDK.h"
#import "NSString+Random.h"
#import "FetchWechatTokenApi.h"
#import "UIImage+Compress.h"
#import "MBProgressHUD.h"
#import "FetchWechatUserInfoApi.h"

#define WECHAT_APP_ID @"wx8db9cc31a7301c39"
#define WECHAT_APP_KEY @"953c4b78a707a4aac59aad2a9f3150b9"

#define IDENTIFIER_LOGIN @"IDENTIFIER_LOGIN"
#define WECHAT_ERROR_DOMAIN @"DOMAIN_ERROR_WECHAT"

@interface WechatApi () <WXApiDelegate, ResponseDelegate>
@property (nonatomic, copy) NSMutableDictionary *identifierDict; /**< 处于安全性考虑，保存了向微信请求时的state，收到微信回调时会做校验 */
@property (atomic) BOOL isLogining; /**< 标识微信登录是否正在进行中，防止重复请求微信登录 */
@end

@implementation WechatApi

#pragma -
#pragma initialize

/**
 *  获取微信Api的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance {
    static WechatApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WechatApi alloc] init];
    });
    return instance;
}

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _identifierDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [WXApi registerApp:WECHAT_APP_ID];
    }
    return self;
}

#pragma -
#pragma Handle Wechat Callback

/**
 *  处理微信的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url {
    [WXApi handleOpenURL:url delegate:self];
}

#pragma -
#pragma WXApiDelegate Protocol Implemetation

/**
 *  处理微信向应用发送的请求
 *
 *  @param req 请求
 */
-(void)onReq:(BaseReq *_Nonnull)req {
    // 目前不会用到这个方法
}

/**
 *  处理微信向应用发送的响应
 *
 *  @param resp 响应
 */
- (void)onResp:(BaseResp *_Nonnull)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [self handleLoginResponse:(SendAuthResp *)resp];
    }
}

#pragma -
#pragma Login Oper

/**
 *  请求微信登录
 */
- (void)login {
    // 避免微信重复登录
    if (_isLogining) {
        return;
    } else {
        _isLogining  = YES;
    }
    if ([WXApi isWXAppInstalled]) {
        
        // 向微信发送请求
        [WXApi sendReq:[self generateLoginRequest]];
    } else {
        
        _isLogining = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(failure:)]) {
            
            [_delegate failure:nil];
        }
    }

}

/**
 *  生成向微信发送的登录请求
 *
 *  @return 请求
 */
- (SendAuthReq *_Nonnull)generateLoginRequest {
    [_identifierDict setObject:[NSString random] forKey:IDENTIFIER_LOGIN] ;
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = _identifierDict[IDENTIFIER_LOGIN];
    return authReq;
}

/**
 *  处理微信请求回调
 *
 *  @param resp 微信的返回值
 */
- (void)handleLoginResponse:(SendAuthResp *_Nonnull)resp {
    // 如果error code不为0，代表登录时发生错误
    if (resp.errCode != 0 && _delegate &&
        [_delegate respondsToSelector:@selector(failure:)]) {
        [_delegate failure:[NSError errorWithDomain:WECHAT_ERROR_DOMAIN
                                               code:resp.errCode
                                           userInfo:nil]];
        return;
    }
    
    // 如果记录的随机串和回调带回的随机串不一致，那么不做处理
    if (![_identifierDict[IDENTIFIER_LOGIN] isEqualToString:resp.state]) {
        return;
    }
    
    [_identifierDict removeObjectForKey:IDENTIFIER_LOGIN];
    [self fetchAccessTokenWithCode:resp.code];
    
}

/**
 *  微信登录成功后，使用code换取AccessToken和OpenId
 *
 *  @param code 换取AccessToken和OpenId的票据
 */
- (void)fetchAccessTokenWithCode:(NSString *_Nonnull)code {
    NSDictionary *params = @{
                             @"appid"       : WECHAT_APP_ID,
                             @"secret"      : WECHAT_APP_KEY,
                             @"code"        : code,
                             @"grant_type"  : @"authorization_code"};
    
    [[[FetchWechatTokenApi alloc] initWithDelegate:self params:params] call];
}

- (void)fetchUserInfo:(id)resp
{
    NSDictionary *params = @{
                             @"access_token" : resp[@"access_token"],
                             @"openid"       : resp[@"openid"]
                             };
    [[[FetchWechatUserInfoApi alloc] initWithDelegate:self params:params] call];
}

#pragma mark -
#pragma mark Share Oper

- (void)shareImage:(UIImage *_Nonnull)image
        thumbImage:(UIImage *_Nullable)thumb
                to:(WechatScene)scene {
    WXImageObject *imageObject = [WXImageObject object];
    [imageObject setImageData:UIImageJPEGRepresentation(image, 1)];

    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumb];
    [message setMediaObject:imageObject];

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
}

/**
 分享文章到微信
 
 @param articleModel 文章数据
 @param scene 分享微信场景
 */
- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(WechatScene)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = articleModel.title;
    message.description = @"西瓜头条";
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:articleModel.cover.firstObject];
    UIImage *scaleImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    if (image == nil) {
        image = [UIImage imageNamed:@"logo"];
    }
    if (articleModel.type.integerValue == 2) {
        
        [message setThumbImage:[UIImage combine:scaleImage otherImage:[UIImage imageNamed:@"play_video.png"]]];

    } else {
        
        [message setThumbImage:scaleImage];
    }
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    if (articleModel.type.integerValue == 2) {
        webpageObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%@", [UserManager currentUser].videoShare, articleModel.articleId];
    } else{
        
        webpageObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%@", [UserManager currentUser].infoFlowShare, articleModel.articleId];
    }
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
}

#pragma -
#pragma ResponseDelegate Protocol Implemetation

/**
 *  换取AccessToken和OpenId，请求成功时的回调
 *
 *  @param request  原始请求
 *  @param response 请求返回值
 */
- (void)request:(NetworkRequest *)request success:(id)response {
    _isLogining = NO;
    
    if ([request.url isEqualToString:URL_FETCH_WECHAT_USERINFO]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(success:)]) {
            [_delegate success:response];
        }
        
        return;
    } else {
        
        // 错误码不为0，代表请求失败
        if (response[@"errcode"] && ![response[@"errcode"] isEqual:@0]) {
            [self request:request failure:[NSError errorWithDomain:WECHAT_ERROR_DOMAIN
                                                              code:[response[@"errcode"] longValue]
                                                          userInfo:response]];
            return;
        }
        [self fetchUserInfo:response];
    }
    
    
}

/**
 *  换取AccessToken和OpenId，请求失败时的回调
 *
 *  @param request  原始请求
 *  @param error    错误信息
 */
- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    _isLogining = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(failure:)]) {
        [_delegate failure:error];
    }
}

@end
