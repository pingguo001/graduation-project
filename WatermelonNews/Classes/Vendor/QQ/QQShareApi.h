//
//  QQShareApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticleModel.h"

typedef NS_ENUM(NSUInteger, QQScene) {
    QQSceneQFriend,  /**< QQ好友 */
    QQSceneQZone, /**< QQ空间 */
};

@interface QQShareApi : NSObject

+ (instancetype _Nullable )sharedInstance;

/**
 QQ分享
 
 @param articleModel 文章
 @param scene QQ好友或QQ空间
 */
- (void)shareNewsArticle:(NewsArticleModel *_Nullable)articleModel
                      to:(QQScene)scene;


/**
 *  处理QQ分享的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url;

@end
