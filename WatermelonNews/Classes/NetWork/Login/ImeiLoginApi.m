//
//  ImeiLoginApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ImeiLoginApi.h"
#import "AppInfo.h"
#import <UIKit/UIDevice.h>
#import "UIDevice+Info.h"

@interface ImeiLoginApi ()<ResponseDelegate, Api>

@end

@implementation ImeiLoginApi

#pragma -
#pragma inialize

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nullable)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma -
#pragma Api Protocol Implementation

/**
 *  获取请求接口地址
 *
 *  @return 请求地址
 */
- (NSString *_Nonnull)url {
    return [URL_BASE_NEWS stringByAppendingString:imeiLoginUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    
    return [self cipherParamsWithQuery:[self concatParams:_params]];
}

/**
 *  获取请求接口回调
 *
 *  @return 请求回调
 */
- (id<ResponseDelegate> _Nullable)delegate {
    return _delegate;
}

/**
 *  调用请求
 */
- (void)call {
    [self sendWithType:POST priority:PRIORITY_HIGHEST interrupt:YES];
}

/**
 *  添加额外的参数
 *
 *  @param raw 原始从外部传进来的参数
 *ssid=\"pocketmoney_5G\"
 &packageName=com.xigua.infoflow
 &mac=F4:09:D8:12:5E:96
 &appHash=92bd95ba81e3fa8c7885e7de9388e28b
 &displayHeight=1920&
 network=WIFI
 &androidId=cb067c0816b60c0d
 &clientVersionNumber=3.2.0000
 &imei=A0000048B1FBBE
 &clientVersionCode=320000
 &androidVersion=5.0
 &clientChannel=lingyongqian
 &displayWidth=1080
 &oper=imeiLogin&hardware=qcom
 &apiLevel=21
 &imsi=460030131277100
 &model=SM-N9009
 
 *  @return 添加好之后的参数结果
 */
- (NSDictionary *_Nonnull)concatParams:(NSDictionary *_Nullable)raw {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:10];
    if (raw != nil) {
        [paramDic setDictionary:raw];
    }
    [paramDic setObject:[[UIDevice currentDevice] oidfa] forKey:@"imei"];
    [paramDic setObject:[[UIDevice currentDevice] oidfa] forKey:@"idfa"];
    [paramDic setObject:[[UIDevice currentDevice] macAddress] forKey:@"mac"];
    [paramDic setObject:[[UIDevice currentDevice] identifier] forKey:@"model"];
    [paramDic setObject:[[UIDevice currentDevice] identifier] forKey:@"hardware"];
    [paramDic setObject:[[UIDevice currentDevice] screenHeight] forKey:@"displayHeight"];
    [paramDic setObject:[[UIDevice currentDevice] screenWidth]forKey:@"displayWidth"];
    [paramDic setObject:[AppInfo build] forKey:@"apiLevel"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"sys_version"];
    [paramDic setObject:[[UIDevice currentDevice] internetStatus] forKey:@"network"];
    [paramDic setObject:[[UIDevice currentDevice] ssid] forKey:@"ssid"];
    [paramDic setObject:[AppInfo version] forKey:@"clientVersionNumber"];
    [paramDic setObject:[[AppInfo version] stringByReplacingOccurrencesOfString:@"." withString:@""] forKey:@"clientVersionCode"];
    [paramDic setObject:CLIENTCHANNEL forKey:@"clientChannel"];
    [paramDic setObject:[AppInfo bundleID] forKey:@"packageName"];
    [paramDic setObject:@"" forKey:@"appHash"];
    
    WNLog(@"imeiLogin参数：%@", paramDic);

    return [paramDic copy];
}

@end
