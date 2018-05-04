//
//  SplashAdApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/14.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#define APPKEY      @"1106417984"
#define PLACEMENTID @"4010924610389094"

#import "SplashAdApi.h"

@interface SplashAdApi () <GDTSplashAdDelegate>

@property (weak, nonatomic) id<SplashAdApiDelegate>delegate;
@property (retain, nonatomic) GDTSplashAd *splash;
@property (retain, nonatomic) UIView *bottomView;

@end

@implementation SplashAdApi

- (id)initTencentAdWithDelegate:(id<SplashAdApiDelegate>)delegate
{
    if (self = [super init]) {

        _delegate = delegate;
        //开屏广告初始化并展示代码
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:APPKEY placementId:PLACEMENTID];
            splashAd.delegate = self;//设置代理
            //设置开屏拉取时长限制，若超时则不再展示广告
            splashAd.fetchDelay = 3;
            //设置开屏底部自定义LogoView，展示半屏开屏广告
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
            UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_anz"]];
            [_bottomView addSubview:logo];
            logo.center = _bottomView.center;
            _bottomView.backgroundColor = [UIColor whiteColor];
            UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
            //如果window已有弹出的视图，会导致广告无法弹出，页面卡死，这里需要先把视图关闭，再弹出广告
            if (fK.rootViewController.presentedViewController != nil) {
                [fK.rootViewController dismissViewControllerAnimated:NO completion:nil];
            }
            [splashAd loadAdAndShowInWindow:fK withBottomView:_bottomView];
            _splash = splashAd;
            
        }
    }
    return self;
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    WNLog(@"%s%@",__FUNCTION__,error);
    [self.delegate splashAdClosed];
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
}
-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    [TalkingDataApi trackEvent:TD_CLICK_TENCENTAD];
}
//跳过
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    [self.delegate splashAdClosed];
    [TalkingDataApi trackEvent:TD_CLOSE_TENCENTAD];

}
-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    [self.delegate splashAdClosed];

}
-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    [TalkingDataApi trackEvent:TD_SHOW_TENCENTAD];

}
/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    WNLog(@"%s",__FUNCTION__);
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    [self.delegate splashAdClosed];

}

@end
