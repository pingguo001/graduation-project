//
//  WechatApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "NewsArticleModel.h"

typedef NS_ENUM(NSUInteger, WechatScene) {
    WechatSceneSession,  /**< 微信好友 */
    WechatSceneTimeline, /**< 朋友圈 */
    WechatSceneFavorite, /**< 微信收藏 */
};

/**
 *  本协议是用于请求微信API后的回调
 */
@protocol WechatAPIDelegate <NSObject>

/**
 *  调用微信API成功时的回调
 *
 *  @param response 返回值
 */
- (void)success:(NSDictionary *_Nonnull)response;

/**
 *  调用微信API失败时的回调
 *
 *  @param error 错误信息
 */
- (void)failure:(NSError *_Nonnull)error;

@end

@interface WechatApi : NSObject 

@property(nonatomic, weak) id <WechatAPIDelegate> _Nullable delegate; /**< 遵循WechatAPIDelegate协议的对象 */

/**
 *  获取微信Api的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance;

/**
 *  请求微信登录
 */
- (void)login;

/**
 *  分享图片到微信
 *
 *  @param image 要分享的图片本地地址
 *  @param thumb 分享图片的缩略图
 *  @param scene 分享微信场景
 */
- (void)shareImage:(UIImage *_Nonnull)image
        thumbImage:(UIImage *_Nullable)thumb
                to:(WechatScene)scene;

/**
 分享文章到微信

 @param articleModel 文章数据
 @param scene 分享微信场景
 */
- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(WechatScene)scene;

/**
 *  处理微信的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url;

@end
