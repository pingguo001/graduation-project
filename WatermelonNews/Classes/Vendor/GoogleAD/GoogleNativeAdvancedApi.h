//
//  GoogleNativeAdvancedApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleAdModel.h"

@protocol GoogleNativeAdvancedApiDelegate <NSObject>

- (void)googleNativeAdvancedDidFetchSuccess:(NSArray *)dataArray;
- (void)googleNativeAdvancedDidFetchFailure:(NSError *)error;

@end

@interface GoogleNativeAdvancedApi : NSObject

/**
 初始化Google广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initGoogleAdWithController:(UIViewController *)controller delegate:(id<GoogleNativeAdvancedApiDelegate>)delegate;

/**
 拉取广告数据
 */
- (void)fetchNativeAdvanced;


@end
