//
//  GoogleAdManager.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GoogleAdManager.h"
#import "GoogleNativeAdvancedApi.h"

@interface GoogleAdManager ()<GoogleNativeAdvancedApiDelegate>

@property (strong, nonatomic) GoogleNativeAdvancedApi *adApi;

@end

@implementation GoogleAdManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static GoogleAdManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [GoogleAdManager new];

    });
    return manager;
}

- (void)initWihtRootViewController:(UIViewController *)controller
{
    self.adApi = [[GoogleNativeAdvancedApi alloc] initGoogleAdWithController:controller delegate:self];
    
}

- (void)fetchGoogleAd
{
    if ([GoogleAdManager sharedManager].fetchType != FetchGoogleAdGoing) {
        [self.adApi fetchNativeAdvanced];
        [GoogleAdManager sharedManager].fetchType = FetchGoogleAdGoing;
    }
}

- (void)googleNativeAdvancedDidFetchSuccess:(NSArray *)dataArray
{
    self.adArray = dataArray.mutableCopy;
    [GoogleAdManager sharedManager].fetchType = FetchGoogleAdEnd;
}

- (void)googleNativeAdvancedDidFetchFailure:(NSError *)error
{
    
}

@end
