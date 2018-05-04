//
//  RootTabBarController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "RootTabBarController.h"
#import "WNNavigationController.h"
#import "NewsViewController.h"
#import "TaskAndExchangeController.h"
#import "TaskListViewController.h"
#import "ExchangeMainViewController.h"
#import "NewsCategoryModel.h"
#import "ElectricizeController.h"
#import "JobViewController.h"
#import "UserManager.h"
#import "ArticleDatabase.h"
#import "UserViewController.h"
#import "AppInfo.h"
#import "PackageManager.h"
#import "TimelineViewController.h"

@interface RootTabBarController ()

@property (strong, nonatomic) UITabBarItem *tempBarItem;
@property (nonatomic, strong) PackageManager      *packageManager;    /**< 安装包管理的实例对象 */

@end

@implementation RootTabBarController
{
    BOOL shouldAutorotate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UserManager currentUser].applicationMode.integerValue == 0) {
        
        //进入应用上传本地安装包
        _packageManager = [[PackageManager alloc] init];
        [_packageManager uploadDevicePackage];
    }
    
    [self configureTabBar];
    
    [self configureChildrenConroller];
    
    if ([UserManager currentUser].isDelete.integerValue != 1) {
        
        [[ArticleDatabase sharedManager] deleteArticleInfoFromDisk];
        [[UserManager currentUser] setIsDelete:@"1"];
    }
    [[ArticleDatabase sharedManager] deleteOverdueArticle];
    
    
    //注册旋转屏幕的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autorotateInterface:) name:@"InterfaceOrientationNotification" object:nil];
    
}

-(void)autorotateInterface:(NSNotification *)notifition
{
    shouldAutorotate = [notifition.object boolValue];
}

/**
 *
 *  @return 是否支持旋转
 */
-(BOOL)shouldAutorotate
{
    WNLog(@"======%d",shouldAutorotate);
    return shouldAutorotate;
}

/**
 *  适配旋转的类型
 *
 *  @return 类型
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (!shouldAutorotate) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)configureTabBar
{
    [[UITabBarItem appearanceWhenContainedIn:[RootTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithString:COLOR8C8C8C]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearanceWhenContainedIn:[RootTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithString:COLOR39AF34] } forState:UIControlStateSelected];
}

- (void)configureChildrenConroller
{
#ifdef DEBUG
//    [[UserManager currentUser] setSensitiveArea:@"0"];  //VPN无效，测试环境暂时都是非敏感地区
//    [[UserManager currentUser] setApplicationMode:@"0"]; //审核模式
#else
#endif
    
    [self addNewsController];
    [self addTimelineController];
    [self addElectricizeController];
    
    NSInteger mode = [UserManager currentUser].applicationMode.integerValue;
    switch (mode) {
//        case 0:{ //完整功能
//            if ([UserManager currentUser].sensitiveArea.integerValue == 1) { //敏感地区
//                [self addNewsController];
//                [self addExchangeController];
//            } else {    //非敏感地区
//                if ([UserManager currentUser].taskOrder.integerValue == 1) {
//
//                    [self addTaskController];  //任务在前
//                    [self addNewsController];
//                    [self addExchangeController];
//
//                } else {
//
//                    [self addNewsController];  //新闻在前
//                    [self addTaskController];
//                }
//
//            }
//            break;
//        }
//        case 1:{ //审核
//            [self addNewsController];
//            [self addTimelineController];
//            [self addElectricizeController];
//            [self addUserController];
//            [self addExchangeController];
//
//
//            [[RongCloudManager sharedManager] loginRongCloud]; //审核模式登录融云
//            break;
//        }
    }
}

- (void)addNewsController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.dataArray = [NewsCategoryModel mj_objectArrayWithKeyValuesArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"category"][@"category"]];
    [self addChildViewController:newsVC title:@"阅读赚钱" image:@"tab_readmoney_default" selectedImage:@"tab_readmoney_highlight" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
    self.tempBarItem = newsVC.tabBarItem;
}

- (void)addTaskController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    TaskListViewController *taskVC = [[TaskListViewController alloc]init];
    [self addChildViewController:taskVC title:@"任务" image:@"tab_task_default" selectedImage:@"tab_task_highlight"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
}

- (void)addExchangeController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    ExchangeMainViewController *exchangeVC = [[ExchangeMainViewController alloc]init];
    [self addChildViewController:exchangeVC title:@"兑换" image:@"tab_ex_default" selectedImage:@"tab_ex_highlight"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
}

- (void)addElectricizeController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    ElectricizeController *electricizeVC = [[ElectricizeController alloc]init];
    [self addChildViewController:electricizeVC title:@"充电" image:@"tab_charge_default" selectedImage:@"tab_charge_highlight"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
}

- (void)addTimelineController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    TimelineViewController *timelineVC = [[TimelineViewController alloc]init];
    [self addChildViewController:timelineVC title:@"圈子" image:@"tab_btn_headline" selectedImage:@"tab_btn_headline_pressed"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
}

- (void)addUserController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    UserViewController *userVC = [[UserViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:userVC title:@"我的" image:@"tab_my" selectedImage:@"tab_my_slick"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[WNNavigationController class]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.tempBarItem isEqual:item]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NewsRefeshNotifiCation object:nil];
    } else {
        
        self.tempBarItem = item;

    }
    if ([item.title isEqualToString:@"任务"]) {
        [TalkingDataApi trackEvent:TD_CLICK_TASK_TAB];
    }
    
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
