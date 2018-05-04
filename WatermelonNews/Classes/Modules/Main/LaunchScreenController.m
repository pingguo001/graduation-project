//
//  LaunchScreenViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/28.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "LaunchScreenController.h"
#import "NewsCategoryModel.h"
#import "NewsCategoryApi.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "LoginManager.h"
#import "JPushApi.h"
#import "UserManager.h"
#import "SplashAdApi.h"
#import "NewsShareApi.h"

@interface LaunchScreenController ()<ResponseDelegate, LoginResponseDelegate,SplashAdApiDelegate>

@property (strong, nonatomic) NewsCategoryApi *categoryApi;
@property (strong, nonatomic) LoginManager    *manager;
@property (strong, nonatomic) SplashAdApi     *splashAdApi;
@property (strong, nonatomic) NewsShareApi    *shareApi;
@property (assign, nonatomic) BOOL isCategory;

@end

@implementation LaunchScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgorundImageView];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:InstallTime]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",time(0)] forKey:InstallTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _manager = [[LoginManager alloc] init];
    _manager.delegate = self;
    [_manager login];
    
}

- (void)setupBackgorundImageView
{
    UIImageView *imageView = [UIImageView new];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.image = [UIImage imageNamed:@"start1080"];
    [self.view addSubview:imageView];
}

#pragma mark - LoginResponseDelegate
- (void)loginFailure:(NSError *)error
{
    if (error.code == -1009) {
        [_manager login];  //处理第一次安装，没有允许网络时无法打开应用问题（一直发送无效的网络请求没关系）
    }
    if (error.code == 3840 || error.code == -1001) {
        [AlertControllerTool alertControllerWithViewController:self title:@"提示\n" message:@"登录超时，请重新尝试" cancleTitle:@"" sureTitle:@"重新登录" cancleAction:nil sureAction:^{
            
            [_manager login];
            
        }];
    }
}

- (void)loginSuccess:(NSDictionary *)result
{

    [self requestCategoryData];  //分类数据
    [self requestShareUrl];    //分享接口
    [JPushApi registerAlias:[UserManager currentUser].deviceId];
    //开屏广告
    if ([UserManager currentUser].applicationMode.integerValue == 0 && [UserManager currentUser].registrationDays.integerValue >= 1) {
        self.splashAdApi = [[SplashAdApi alloc] initTencentAdWithDelegate:self];
    }
}

//请求头部
- (void)requestCategoryData{
    
    _categoryApi = [[NewsCategoryApi alloc] initWithDelegate:self];
    [_categoryApi call];
}

//请求分享Url
- (void)requestShareUrl{
    
    _shareApi = [[NewsShareApi alloc] initWithDelegate:self];
    [_shareApi call];

}

#pragma mark - ResponseDelegate

- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:shareUrl]) {
        
        [[UserManager currentUser] setInfoFlowShare:response[@"arrLinks"][@"infoFlowShare"]];
        [[UserManager currentUser] setVideoShare:response[@"arrLinks"][@"videoShare"]];
        [[UserManager currentUser] setArrLinks:[response[@"arrLinks"] mj_JSONString]];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"category"];
        _isCategory = YES;
        if ([UserManager currentUser].applicationMode.integerValue == 0 && [UserManager currentUser].registrationDays.integerValue >= 1) {
        } else {
            [self enterNewsRootViewController];
        }
    }
    
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    
}

//跳过广告
- (void)splashAdClosed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isCategory) {
            [self enterNewsRootViewController];
        }
    });
}

//进入主控制器
- (void)enterNewsRootViewController;
{

    RootTabBarController *tabVC = [RootTabBarController new];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabVC;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterMain" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 是否支持旋转
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
