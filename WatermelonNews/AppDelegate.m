//
//  AppDelegate.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "LaunchScreenController.h"
#import "JPushApi.h"
#import "PlayManager.h"
#import "Jailbroken.h"
#import "SplashAdApi.h"

@interface AppDelegate ()<SplashAdApiDelegate>

@property (strong, nonatomic) SplashAdApi *splashAdApi;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[self antiJailbroken]; //越狱不能使用
    //root
    [self addMainWindow];
    //注册极光推送
    [JPushApi apiWithOptions:launchOptions];
    [JPushApi clearBadge];
    //数据统计
    //[TalkingDataApi initSession];
    //QQ
    //[TencentQQApi sharedInstance];
    //配置音频信息
    [PlayManager config];
    
    
    [TalkingDataApi trackEvent:TD_OPEN_TIMES];
    [TalkingDataApi trackPageBegin:TD_STAY_IN_APPLICATION];
    
    return YES;
}

- (void)antiJailbroken {
    int res = 0;
    [Jailbroken detect:&res];
    if (res != 0) {
        exit(0);
    }
}

- (void)addMainWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[LaunchScreenController alloc]init];
    [self.window makeKeyAndVisible];
}

#pragma mark- JPUSHRegisterDelegate
//注册成功
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPushApi registerDeviceToken:deviceToken];
    NSLog(@"%@", deviceToken);
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPushApi executeRemoteNotification:userInfo withFetchCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    [[WechatApi sharedInstance] handleOpenUrl:url];
    [[TencentQQApi sharedInstance] handleOpenUrl:url];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [JPushApi clearBadge];
    [[NSNotificationCenter defaultCenter] postNotificationName:UploadShowInfoNotifiCation object:nil];
    //允许后台播放音乐
    [application beginBackgroundTaskWithExpirationHandler:nil];
    [TalkingDataApi trackPageEnd:TD_STAY_IN_APPLICATION];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:@"adtime"];

}

#pragma mark - 锁屏控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    // NSLog(@"远程控制回调");
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:{
            [[PlayManager sharManager] play];
        }
            break;
        case UIEventSubtypeRemoteControlPause:{
            [[PlayManager sharManager] pause];
            [PlayManager sharManager].currentPlayModel.isPlay = NO;
            //通知专辑详情界面刷新播放界面
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Play_Change object:@"pause"];
            
        }
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [[PlayManager sharManager] playOther:YES];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[PlayManager sharManager] playOther:NO];
            break;
            
        default:
            break;
    }
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [JPushApi clearBadge];
    [TalkingDataApi trackEvent:TD_OPEN_TIMES];
    [TalkingDataApi trackPageBegin:TD_STAY_IN_APPLICATION];
    
    //开屏广告每次进入APP展示（时间间隔3分钟）
    if (time(0) - [[[NSUserDefaults standardUserDefaults] objectForKey:@"adtime"] longLongValue] > 180 && [UserManager currentUser].applicationMode.integerValue == 0 && [UserManager currentUser].registrationDays.integerValue >= 1) {
        self.splashAdApi = [[SplashAdApi alloc] initTencentAdWithDelegate:self];
    }
}
//开屏广告展示完毕
- (void)splashAdClosed
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
