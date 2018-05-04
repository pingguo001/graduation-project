//
//  TencentQQApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/10.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QQScene) {
    QQSceneSession,  /**< QQ好友 */
    QQSceneQzone, /**< QQ空间 */
};

typedef void(^SendReqCallback)(int code, NSString *_Nullable description);

@interface TencentQQApi : NSObject


- (void)loginCallback:(SendReqCallback _Nullable)callback;

/**
 *  获取QQApi的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance;

/**
 处理QQ请求的回调
 
 @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url;

/**
 分享文字消息到QQ
 
 @param text 要分享的文字
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareTextMessage:(NSString *_Nonnull)text
                      to:(QQScene)scene
                callback:(SendReqCallback _Nullable)callback;

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
          callback:(SendReqCallback _Nullable)callback;

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
            callback:(SendReqCallback _Nullable)callback;

/**
 QQ分享
 
 @param articleModel 文章
 @param scene QQ好友或QQ空间
 */
- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(QQScene)scene
                      callback:(SendReqCallback _Nullable)callback;

/**
 *  判断用户当前手机是否能加入QQ群
 *
 *  @return 能加入返回YES，否则返回NO
 */
+ (BOOL)canJoinGroup;

/**
 *  加入指定的QQ群，如果Group或Key任一为空，那么加入默认的QQ群
 *
 *  @param group QQ群的群号
 *  @param key   QQ群的Key
 */
+ (void)joinGroup:(NSString *_Nullable)group
          withKey:(NSString *_Nullable)key;
@end
