//
//  MYProgressHUD.m
//  Model1
//
//  Created by yedexiong on 16/12/16.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "MYProgressHUD.h"
#import "SVProgressHUD.h"

@implementation MYProgressHUD

+(void)load
{    //设置hud背景颜色
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //设置移除时间
    [SVProgressHUD setMinimumDismissTimeInterval:3.0f];
    //设置遮罩类型
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+(void)showStatus:(NSString *)statues
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD  showWithStatus:statues];
        });
    }else{
        [SVProgressHUD  showWithStatus:statues];
    }
}

+(void)showSuccessStatus:(NSString *)statues
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:statues];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:statues];
    }

}
+(void)showErrorStatus:(NSString *)statues
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
        });
    }else{
         [SVProgressHUD showErrorWithStatus:statues];
    }

}

+(void)showMessage:(NSString *)statues
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }

}
+(void)showProgress:(CGFloat)progress
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress];
        });
    }else{
        [SVProgressHUD showProgress:progress];
    }
   
}
+(void)dismiss
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        [SVProgressHUD dismiss];
    }
}


@end
