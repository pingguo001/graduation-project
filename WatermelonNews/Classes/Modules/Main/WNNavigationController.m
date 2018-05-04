//
//  WNNavigationController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "WNNavigationController.h"

@interface WNNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableRightGesture = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    [self configureNavBarTheme];
    self.useSystemBackBarButtonItem = YES;
}

- (void)configureNavBarTheme
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithString:COLOR39AF34],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
    
    UIImage *img = [UIImage imageWithColor:[UIColor colorWithString:COLOR323941] size:CGSizeMake(1, 1)];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor: [UIColor colorWithString:COLOR39AF34]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return self.enableRightGesture;
}

#pragma mark - override

// override pushViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)leftAction
{
    [self popViewControllerAnimated:YES];
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
