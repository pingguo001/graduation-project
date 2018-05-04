//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "ResponseDelegate.h"
#import "BaseApi.h"
#import "AES256.h"
#import "NSDictionary+JSON.h"
#import "NetworkErrorDefine.h"
#import "NetworkRequest.h"
#import "RequestScheduler.h"
#import "InitLoginApi.h"
#import "ImeiLoginApi.h"
#import "LinkStartApi.h"
#import "UIDevice+Info.h"
#import "UserManager.h"
#import "RequestScheduler.h"
#import "ErrorResolver.h"

@interface BaseApi()
@property (nonatomic, weak) id<Api> api; /**< 实现Api接口的对象，是继承BaseApi的类 */
@property (strong, nonatomic) ErrorResolver *resolver;
@end

/**
 *  BaseApi的分类，把加密和解密的部分拆分了出来
 */
@implementation BaseApi (Cryptor)

/**
 *  加密给定的字典数据，先把字典数据转换成了JSON之后加密
 *
 *  @param data 要加密的数据
 *  @param key  加密的密钥
 *
 *  @return 加密后的字符串
 */
- (NSString *_Nonnull)encryptData:(NSDictionary *_Nonnull)data
                          withKey:(NSString *_Nonnull)key {
    return [AES256 encryptString:[data json] withKey:key];
}

/**
 *  解密给定的字符串，解密后的数据是JSON，转换成字典输出
 *
 *  @param data 要解密的串
 *  @param key  解密的密钥
 *
 *  @return 解密后的字典数据
 */
- (NSDictionary *_Nonnull)decryptData:(NSString *)data
                              withKey:(NSString *_Nonnull)key {
    return [NSDictionary dictionaryWithJSON:[AES256 decryptString:data withKey:key]];
}

@end

@implementation BaseApi

/**
 *  初始化方法
 *
 *  事实上，这个类我设计为所有请求Api的公共父类，这个类是不会被直接初始化的，
 *  所以在初始化时内部，检查了是否遵守Api协议，而本类自己没有遵守这个协议，
 *  那么如果直接初始化这个对象必然会崩溃，同时也可以限制子类们必须遵守这个协议。
 *
 *  @return 实例对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 检查是否遵守Api协议，否则崩溃
        if ([self conformsToProtocol:@protocol(Api)]) {
            self.api = (id<Api>)self;
        } else {
            NSAssert(NO, @"Subclass must be conforms to Api protocol");
        }
        _resolver = [ErrorResolver new];
    }
    return self;
}

/**
 *  根据优先级发送请求，非打断模式
 *
 *  @param type     请求的类型，Get、Post
 *  @param priority 优先级，是-20～20的数，数字越大，优先级越高
 *
 */
- (void)sendWithType:(Type)type priority:(Priority)priority {
    
    NSAssert(priority >= -20 && priority <= 20, @"Priority must between -20 and 20");
    
    NetworkRequest *request = [NetworkRequest requestWithUrl:[self.api url]
                                                  parameters:[self.api params]
                                                    delegate:self
                                                    priority:priority
                                                        type:type];
    
    [[RequestScheduler sharedInstance] enqueueRequest:request];
}

/**
 *  根据优先级发送请求
 *
 *  @param type      请求的类型，Get、Post
 *  @param priority  优先级，是-20～20的数，数字越大，优先级越高
 *  @param interrupt 是否需要打断模式
 *
 */
- (void)sendWithType:(Type)type priority:(Priority)priority interrupt:(BOOL)interrupt {
    NSAssert(priority >= -20 && priority <= 20, @"Priority must between -20 and 20");
    
    NetworkRequest *request = [NetworkRequest requestWithUrl:[self.api url]
                                                  parameters:[self.api params]
                                                    delegate:self
                                                    priority:priority
                                                        type:type];
    
    [[RequestScheduler sharedInstance] enqueueRequest:request needInterrupt:interrupt];
}

- (NSDictionary *_Nonnull)decryptResponse:(id _Nonnull)response {
    if ([response[@"encrypt"] isEqual:@1]) {
        if ([[response allKeys] containsObject:@"errorCode"]) {
            return [self decryptData:response[@"data"] withKey:[UserManager currentUser].token];
        }
        return [self decryptData:response[@"data"] withKey:[UserManager currentUser].iccToken];
    } else {
        return response[@"data"];
    }
}

/**
 *  请求成功的回调，这里预先检查了错误码，当错误码不为0时，调用请求失败的方法
 *
 *  @param request  原始请求
 *  @param response 请求返回值
 */
- (void)request:(NetworkRequest *)request success:(id)response {
    WNLog(@"%@", response);
    int errorCode = 0;
    if ([request.url containsString:URL_BASE_NEWS]) {
        errorCode = [response[@"errorCode"] intValue];
    } else {
        errorCode = [response[@"code"] intValue];
    }
    NSError *error = [NSError errorWithDomain:NETWORK_ERROR_DOMAIN code:errorCode userInfo:response];
    
    if (errorCode == 0) { // 错误码为0
        if ([self.api delegate] && [[self.api delegate] respondsToSelector:@selector(request:success:)]) {
            [[self.api delegate] request:request success:[self decryptResponse:response]];
        }
    } else { // 错误码不为0
        [self request:request failure:error];
        [self.resolver resolveError:error ofRequest:request];
        [self.resolver resendRequests];
    }
}

/**
 *  请求失败的回调
 *
 *  @param request 原始请求
 *  @param error   错误信息
 */
- (void)request:(NetworkRequest *)request failure:(NSError *)error {
    WNLog(@"请求失败错误信息：%@", error);
    if ([self.api delegate] && [[self.api delegate] respondsToSelector:@selector(request:failure:)]) {
        [[self.api delegate] request:request failure:error];
    }
    
    if (![request.url containsString:initLoginUrl] && (error.code == -1009)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示\n" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    if (error.code == 3840 || error.code == -1001) {
        if (![request.url containsString:URL_BASE_ICC] && ![request.url containsString:imeiLoginUrl] && ![request.url containsString:linkStartUrl]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示\n" message:[NSString stringWithFormat:@"%@加载超时，请稍后再试",@""] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end

/**
 *  BaseApi的分类，把生成完整参数的部分拆分了出来
 */
@implementation BaseApi (ParamsGenerator)

/**
 *  生成非加密请求的请求参数
 *
 *  @param query 真正的请求参数，这部分是未加密的
 *
 *  @return 非加密的请求参数
 */
- (NSDictionary *_Nonnull)plainParamsWithQuery:(NSDictionary *_Nonnull)query {
    
    return @{
             @"q" : [query json],
             @"e" : @0, /**< 代表了q中的请求不是加密的 */
             @"a" : [[UIDevice currentDevice] account]
             };
}

/**
 *  生成加密请求的请求参数(news)
 *
 *  @param query 真正的请求参数，这部分是加密的
 *
 *  @return 加密的请求参数
 */
- (NSDictionary *_Nonnull)cipherParamsWithQuery:(NSDictionary *_Nonnull)query {
    
    NSString *token     = [[UserManager currentUser] token];    /**< 从服务端获取的token，是请求加密的密码 */
    return @{
             @"q" : [self encryptData:query withKey:token],
             @"e" : @1, /**< 代表了q中的请求是加密的 */
             @"a" : [[UIDevice currentDevice] account]
             };
}

/**
 *  生成加密请求的请求参数(ICC)
 *
 *  @param query 真正的请求参数，这部分是加密的
 *
 *  @return 加密的请求参数
 */
- (NSDictionary *)cipherParamsICCWithQuery:(NSDictionary *)query
{
    NSString *token     = [[UserManager currentUser] iccToken];    /**< 从服务端获取的token，是请求加密的密码 */
    NSString *identity  = [[UserManager currentUser] identity];
    
    return @{
             @"q" : [self encryptData:query withKey:token],
             @"e" : @1, /**< 代表了q中的请求是加密的 */
             @"a" : identity
             };
}

/**
 *  生成真正的请求参数
 *
 *  @param params 除了所有请求共有的请求参数，外部传进来的额外的请求参数
 *
 *  @return 真正的请求参数
 */
- (NSDictionary *_Nonnull)queryWithParams:(NSDictionary *_Nullable)params {
    NSMutableDictionary *query  = [NSMutableDictionary dictionaryWithCapacity:10];

    if ([[UserManager currentUser] deviceId]) {
        [query setObject:[[UserManager currentUser] deviceId]    forKey:@"device"];
    }
    [query setObject:[[UIDevice currentDevice] oidfa]        forKey:@"idfa"];
    [query setObject:[[UIDevice currentDevice] oidfa]       forKey:@"oidfa"];
    [query setObject:[[UIDevice currentDevice] idfv]        forKey:@"idfv"];
    [query setObject:[[UIDevice currentDevice] timestamp]   forKey:@"timestamp"];
    [query setObject:APPLICATIONCHANNEL forKey:@"channel"];

    if (params != nil) {
        [query addEntriesFromDictionary:params];
    }
    
    return [query copy];
}

@end
