//
//  TencentQQApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/10.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "TencentQQApi.h"
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UserManager.h"

#define QQAPP_ID @"1106344104"
#define QQAPP_KEY @"mrQV8N3fVwwh1Ukg"

#define URL_JOIN_GROUP @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external"
#define DEFAULT_GROUP_NUMBER @"476531342"
#define DEFAULT_GROUP_KEY    @"QbEhJOzm1oFn2CE2iymQIC5Lvn-EEsBh"

@interface TencentQQApi () <QQApiInterfaceDelegate, TencentLoginDelegate>
@property (nonatomic, strong) SendReqCallback sendReqCallback; /**< 向QQ发送消息后，回调的block */
@property (strong, nonatomic) TencentOAuth *tencentOAuth;
@end

@implementation TencentQQApi

#pragma -
#pragma initialize

/**
 *  获取QQApi的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance {
    static TencentQQApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TencentQQApi alloc] init];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPP_ID andDelegate:self];
#pragma clang diagnostic pop
    }
    return self;
}

- (void)loginCallback:(SendReqCallback _Nullable)callback
{
    _sendReqCallback = callback;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    
    [_tencentOAuth authorize:permissions inSafari:NO];

}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    [_tencentOAuth getUserInfo];
}

/**
 获取用户信息
 
 @param response response.message为用户信息
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    _sendReqCallback(0,response.message);
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
}

/**
 处理QQ请求的回调

 @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url {
    
    [TencentOAuth HandleOpenURL:url];
    [QQApiInterface handleOpenURL:url delegate:self];
}

#pragma -
#pragma mark Share Methods

/**
 分享文字消息到QQ
 
 @param text 要分享的文字
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareTextMessage:(NSString *_Nonnull)text
                      to:(QQScene)scene
                callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;
    
    QQApiObject *txtObj = [QQApiTextObject new];
    
    if (scene == QQSceneSession) {
        QQApiTextObject *obj = [QQApiTextObject new];
        [obj setText:text];
        txtObj = obj;
    } else if (scene == QQSceneQzone) {
        QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject new];
        [obj setTitle:text];
        [obj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        txtObj = obj;
    }
    
    [self shareObject:txtObj toScene:scene];
}

/**
 分享图片到QQ
 
 @param image 要分享的图片
 @param title 分享的标题
 @param description 分享的描述
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareImage:(UIImage *_Nonnull)image
             title:(NSString *_Nonnull)title
       description:(NSString *_Nonnull)description
                to:(QQScene)scene
          callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;

    NSData *imgData = UIImageJPEGRepresentation(image, 0.1);

    QQApiObject *imgObj = nil;
    
    if (scene == QQSceneSession) {
        QQApiImageObject *obj = [QQApiImageObject new];
        [obj setData:imgData];
        [obj setPreviewImageData:imgData];
        [obj setTitle:title];
        [obj setDescription:description];
        imgObj = obj;
    } else if (scene == QQSceneQzone) {
        QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject new];
        [obj setImageDataArray:@[imgData]];
        [obj setTitle:title];
        imgObj = obj;
    }
    
    [self shareObject:imgObj toScene:scene];
}

/**
 分享网页到QQ
 
 @param url 要分享网页的URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param thumb 分享内容的缩略图
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareWebpage:(NSString *_Nonnull)url
               title:(NSString *_Nonnull)title
         description:(NSString *_Nonnull)description
               thumb:(NSString *_Nonnull)thumb
                  to:(QQScene)scene
            callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;

    QQApiNewsObject *newsObj = [QQApiNewsObject new];
    [newsObj setUrl:[NSURL URLWithString:url]];
    [newsObj setTitle:title];
    [newsObj setDescription:description];
    [newsObj setPreviewImageData:[NSData dataWithContentsOfFile:thumb]];
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

/**
 QQ分享
 
 @param articleModel 文章
 @param scene QQ好友或QQ空间
 */
- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(QQScene)scene
                callback:(SendReqCallback _Nullable)callback
{
    _sendReqCallback = callback;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject new];
    if (articleModel.type.integerValue != 2) {
        [newsObj setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", [UserManager currentUser].infoFlowShare, articleModel.articleId]]];
    } else {
        [newsObj setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", [UserManager currentUser].videoShare, articleModel.articleId]]];
    }
    [newsObj setTitle:articleModel.title];
    [newsObj setDescription:@"西瓜头条"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:articleModel.cover.firstObject];
    if (image == nil) {
        image = [UIImage imageNamed:@"logo"];
    }
    UIImage *scaleImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    if (articleModel.type.integerValue == 2) {
        
        [newsObj setPreviewImageData:UIImageJPEGRepresentation([UIImage combine:scaleImage otherImage:[UIImage imageNamed:@"play_video.png"]], 1)];
        
    } else {
        
        [newsObj setPreviewImageData:UIImageJPEGRepresentation(scaleImage, 1)];
    }
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

/**
 分享消息到QQ

 @param obj 要分享的消息对象
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareObject:(QQApiObject *)obj
            toScene:(QQScene)scene {
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (scene == QQSceneSession) {
            QQApiSendResultCode code = [QQApiInterface sendReq:req];
            if (code == EQQAPISENDSUCESS) {
                WNLog(@"success");
            }
        } else if (scene == QQSceneQzone) {
            [QQApiInterface SendReqToQZone:req];
        }
    });
}

#pragma -
#pragma mark QQ Group

/**
 *  判断用户当前手机是否能加入QQ群
 *
 *  @return 能加入返回YES，否则返回NO
 */
+ (BOOL)canJoinGroup {
    NSString *urlString = [NSString stringWithFormat:URL_JOIN_GROUP, DEFAULT_GROUP_NUMBER, DEFAULT_GROUP_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

/**
 *  加入指定的QQ群，如果Group或Key任一为空，那么加入默认的QQ群
 *
 *  @param group QQ群的群号
 *  @param key   QQ群的Key
 */
+ (void)joinGroup:(NSString *_Nullable)group
          withKey:(NSString *_Nullable)key {
    if (group == nil || key == nil) {
        group = DEFAULT_GROUP_NUMBER;
        key = DEFAULT_GROUP_KEY;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_JOIN_GROUP, group, key]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma -
#pragma mark QQApiInterfaceDelegate Protocol Implementation

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
        if (_sendReqCallback) {
            if ([resp.result isEqualToString:@"0"]) {
                _sendReqCallback(0, nil);
            } else {
                _sendReqCallback([resp.result intValue], resp.errorDescription);
            }
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

@end
