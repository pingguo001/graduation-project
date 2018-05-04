//
//  UITabBarController+ChildController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UITabBarController+ChildController.h"

@implementation UITabBarController (ChildController)

- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition navControllerClass:(Class)navControllerClass
{
    [self configureChildViewController:childVc title:title image:image selectedImage:selectedImage imageInsets:imageInsets titlePosition:titlePosition];
    
    // 给控制器 包装 一个导航控制器
    id nav = nil;
    if (navControllerClass == nil) {
        nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    }else {
        nav = [[navControllerClass alloc] initWithRootViewController:childVc];
    }
    
    // 添加为子控制器
    [self addChildViewController:nav];
}

- (void)configureChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition
{
    // 同时设置tabbar和navigationBar的文字
    childVc.title = title;
    childVc.tabBarItem.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //声明显示图片的原始式样 不要渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.imageInsets = imageInsets;
    childVc.tabBarItem.titlePositionAdjustment = titlePosition;
}

@end
