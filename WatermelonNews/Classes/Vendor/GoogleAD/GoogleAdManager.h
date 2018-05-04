//
//  GoogleAdManager.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FetchGoogleAdBegin,
    FetchGoogleAdGoing,
    FetchGoogleAdEnd,
} FetchGoogleAdType;

@interface GoogleAdManager : NSObject

@property (assign, nonatomic) FetchGoogleAdType fetchType;
@property (strong, nonatomic) NSMutableArray *adArray;

+ (instancetype)sharedManager;

- (void)initWihtRootViewController:(UIViewController *)controller;

- (void)fetchGoogleAd;

@end
