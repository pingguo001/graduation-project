//
//  MYProgressHUD.h
//  Model1
//
//  Created by yedexiong on 16/12/16.
//  Copyright © 2016年 yoke121. All rights reserved.
//  基于SVProgressHUD的一层包装

#import <Foundation/Foundation.h>

@interface MYProgressHUD : NSObject

//显示加载loading
+(void)showStatus:(NSString *)statues;
//成功提示
+(void)showSuccessStatus:(NSString *)statues;
//失败提示
+(void)showErrorStatus:(NSString *)statues;
//显示一句话，几秒后消失
+(void)showMessage:(NSString *)statues;
//显示进度环
+(void)showProgress:(CGFloat)progress;
//移除
+(void)dismiss;

@end
