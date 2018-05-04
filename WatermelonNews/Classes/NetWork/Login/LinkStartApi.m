//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "LinkStartApi.h"
#import "UIDevice+Info.h"
#import "Fingerprint.h"
#import "UserManager.h"
#import "AppInfo.h"

@interface LinkStartApi () <ResponseDelegate, Api>
@property(nonatomic, weak) id <ResponseDelegate> delegate; /**< 回调的代理 */
@end

@implementation LinkStartApi

#pragma -
#pragma inialize

/**
 *  初始化方法
 *
 *  @param delegate 请求回调的代理
 *
 *  @return 实例对象
 */
- (instancetype _Nonnull)initWithDelegate:(id <ResponseDelegate> _Nonnull)delegate {
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
    return [URL_BASE_ICC stringByAppendingString:linkStartUrl];
}

/**
 *  获取请求接口参数
 *
 *  @return 请求参数
 */
- (NSDictionary *_Nullable)params {
    return [self plainParamsWithQuery:[self queryWithParams:[self addtionalParams]]];
}

/**
 *  获取请求接口回调
 *
 *  @return 请求回调
 */
- (id<ResponseDelegate> _Nonnull)delegate {
    return _delegate;
}

/**
 *  调用请求
 */
- (void)call {
    [self sendWithType:POST priority:PRIORITY_HIGHEST interrupt:YES];
}

/**
 *  获得请求需要的参数
 *
 *  @return 参数字典
 */
- (NSDictionary *_Nonnull)addtionalParams {
    NSMutableDictionary *add = [NSMutableDictionary dictionaryWithDictionary:[self fingerprintParams]];
    [add setObject:[AppInfo version] forKey:@"app_version"];
    [add setObject:[[UIDevice currentDevice] systemVersion] forKey:@"ios_version"];
    [add setObject:[[UIDevice currentDevice] identifier] forKey:@"identifier"];
    [add setObject:APPLICATIONCHANNEL forKey:@"channel"];
//    [add setObject:@"123456" forKey:@"signature"];

    return [add copy];
}

/**
 *  生成登陆时的指纹参数
 *
 *  @return 生成的指纹参数字典，内部为指纹字符串和生成指纹的时间戳
 *
 *  e.g. @{@"fingerprint":@"gwhowe", @"timestamp":@"142984792"}
 */
- (NSDictionary *_Nonnull)fingerprintParams {
    NSString *idfa = [[UIDevice currentDevice] oidfa];
    NSString *timestamp = [[UIDevice currentDevice] timestamp];
    
    NSMutableString *odd = [[NSMutableString alloc] init];
    NSMutableString *even = [[NSMutableString alloc] init];

    for (NSUInteger i = 0; i < timestamp.length; ++i) {
        if (i % 2 == 0) {
            [odd appendString:[timestamp substringWithRange:NSMakeRange(i, 1)]];
        } else {
            [even appendString:[timestamp substringWithRange:NSMakeRange(i, 1)]];
        }
    }

    return @{
             @"fingerprint" : [Fingerprint generateWithIdfa:idfa key1:odd key2:even],
             @"timestamp" : timestamp,
             };
}

@end
