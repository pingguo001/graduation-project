//
//  WNBaseViewController.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplicationSwitchDelegate <NSObject>
@optional
/**
 *  应用程序进入前台
 *
 */
- (void)applicationDidEnterForeground;

/**
 *  应用程序进入后台
 *
 */
- (void)applicationDidEnterBackground;
@end

//刷新按钮回调
typedef void(^RefreshAction)();

//左右导航按钮回调
typedef void(^PassAction)(UIButton *button);

@interface WNBaseViewController : UIViewController


@property (copy, nonatomic) PassAction leftItemAction;
@property (copy, nonatomic) PassAction rightItemAction;
@property (copy, nonatomic) RefreshAction refreshAction;
@property (strong, nonatomic) UIButton *leftButton;


#pragma mark ===== leftBarButton
/**
 *  设置navigation左按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarLeftItemButtonTitle:(NSString *)title image:(NSString *)image;


#pragma mark ===== rightBarButton

/**
 *  设置navigation右按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarRightItemButtonTitle:(NSString *)title image:(NSString *)image;

@end
