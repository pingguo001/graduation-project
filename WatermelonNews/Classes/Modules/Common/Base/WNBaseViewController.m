//
//  WNBaseViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "WNBaseViewController.h"

@interface WNBaseViewController ()

@end

@implementation WNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self conformsToProtocol:@protocol(ApplicationSwitchDelegate)]) {
        [self observeForegroundNotification];
        [self observeBackgroundNotification];
    }
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    if ([self conformsToProtocol:@protocol(ApplicationSwitchDelegate)]) {
        [self removeForegroundNotificationObserver];
        [self removeBackgroundNotificationObserver];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma Observe & Unobserve Methods

/**
 *  监听程序进入前台的事件
 */
- (void)observeForegroundNotification {
    if ([self respondsToSelector:@selector(applicationDidEnterForeground)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterForeground)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
}

/**
 *  监听程序进入后台的事件
 */
- (void)observeBackgroundNotification {
    if ([self respondsToSelector:@selector(applicationDidEnterBackground)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
}

/**
 *  移除监听程序进入前台
 */
- (void)removeForegroundNotificationObserver {
    if ([self respondsToSelector:@selector(applicationDidEnterBackground)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
    }
}

/**
 *  移除监听程序进入后台
 */
- (void)removeBackgroundNotificationObserver {
    if ([self respondsToSelector:@selector(applicationDidEnterBackground)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
    }
}


/**
 *  设置navigation左按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarLeftItemButtonTitle:(NSString *)title image:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    float titleWidth = [title sizeWithFont:btn.titleLabel.font].width;
    [btn setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];

    btn.frame = CGRectMake(0, 0, titleWidth + 40, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //设置button左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.leftButton = btn;
}

//左按钮点击方法
- (void)leftAction:(UIButton *)sender
{
    self.leftItemAction(sender);
}

/**
 *  设置navigation右按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarRightItemButtonTitle:(NSString *)title image:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    //        btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    float titleWidth = [title sizeWithFont:btn.titleLabel.font].width;
    btn.frame = CGRectMake(0, 0, titleWidth + 40, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //设置button右对齐
//    btn.backgroundColor = [UIColor redColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 33)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)rightAction:(UIButton *)sender
{
    self.rightItemAction(sender);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
