//
//  ShareTool.m
//  Kratos
//
//  Created by Zhangziqi on 16/7/21.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "ShareTool.h"
#import "SDWebImageDownloader.h"
#import "MBProgressHUD.h"
#import "UIViewController+Utils.h"
#import <Social/SLComposeViewController.h>

NSString *const SLServiceTypeWechat = @"com.tencent.xin.sharetimeline";
NSString *const SLServiceTypeQQ = @"com.tencent.mqq.ShareExtension";

NSString *const kShareScene = @"kShareScene";
NSString *const kShareSceneWechat = @"kShareSceneWechat";
NSString *const kShareSceneQQ = @"kShareSceneQQ";

NSString *const kShareContentURL = @"kShareURL";

@implementation ShareTool

+ (void)shareWithScene:(NSString *)scene
            withWebUrl:(NSString *_Nullable)webUrl
        withCompletion:(void(^_Nullable)(BOOL))completion{
    
    NSString *service;
    
    if ([scene isEqualToString:kShareSceneWechat]) {
        service = SLServiceTypeWechat;
    } else if ([scene isEqualToString:kShareSceneQQ]) {
        service = SLServiceTypeQQ;
    }
    
    if (![SLComposeViewController isAvailableForServiceType:service]) {
        return;
    }
    
    [self shareWebUrl:webUrl toService:service withCompleted:completion];
    
}

+ (void)shareWebUrl:(NSString *)webUrl
         toService:(NSString *)service
     withCompleted:(void(^)(BOOL))completed {
    
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view
                                   animated:YES];
    });
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:service];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (vc) {
            [vc addURL:[NSURL URLWithString:webUrl]];
            [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                if (completed) {
                    completed(result);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }];
            [[UIViewController currentViewController] presentViewController:vc
                                                                   animated:YES
                                                                 completion:nil];
            
        } else {
            [hud hideAnimated:YES];
        }
    });
}

@end
