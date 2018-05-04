//
//  ShareTool.h
//  Kratos
//
//  Created by Zhangziqi on 16/7/21.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NewsArticleModel.h"

extern NSString *const kShareScene;
extern NSString *const kShareSceneWechat;
extern NSString *const kShareSceneQQ;
extern NSString *const kShareType;
extern NSString *const kShareTypeImage;
extern NSString *const kShareTypeWebpage;
extern NSString *const kShareContentURL;

@interface ShareTool : NSObject

/**
 调用原生分享

 @key kShareScene 分享目标
 @value kShareSceneWechat 微信分享
 @value kShareSceneQQ QQ分享
 
 @param completion 分享完成后的回调
 */
+ (void)shareWithScene:(NSString *)scene
            withWebUrl:(NSString *_Nullable)webUrl
        withCompletion:(void(^_Nullable)(BOOL))completion;

@end
