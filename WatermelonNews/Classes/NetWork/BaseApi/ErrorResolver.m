//
//  ErrorResolver.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/12.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "ErrorResolver.h"
#import "NetworkErrorDefine.h"
#import "TalkingDataApi.h"
#import "NetworkRequest.h"
#import "UIDevice+Info.h"
#import "RequestScheduler.h"
#import "LoginManager.h"
#import "UserManager.h"
#import "AES256.h"

@interface ErrorResolver()
@property (nonatomic, strong) NSMutableArray<NetworkRequest *> *requests; /**< 保存失败等待重发的请求 */
@property (nonatomic, copy) NSString *oldToken; /**< 保存旧的token，用来重加密请求 */
@property (strong, nonatomic) NSDictionary *errorInfo;

@property (strong, nonatomic) LoginManager *manager;


@end

@implementation ErrorResolver

#pragma mark -
#pragma mark Initialize

/**
 *  初始化
 *
 *  @return 实例对象
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        _requests = [NSMutableArray arrayWithCapacity:10];
        _errorInfo = @{@"1":@"参数为空",
                       @"2":@"参数无法正确解析(参数非json格式)",
                       @"3":@"操作名异常(未空或者非法)",
                       @"4":@"部分参数为空",
                       @"5":@"数据库错误",
                       @"6":@"校验失败(token过期)",
                       @"7":@"未知错误(异常访问)",
                       @"8":@"系统维护",
                       @"9":@"强制升级",
                       @"10":@"加密接口传递非加密数据",};
    }
    return self;
}

#pragma mark -
#pragma mark Public Methods

/**
 *  处理错误
 *
 *  @param error   待处理的错误
 *  @param request 发生错误的请求
 */
- (void)resolveError:(NSError *_Nonnull)error
           ofRequest:(NetworkRequest *_Nullable)request {
    switch (error.code) {
        case ERROR_CODE_INVALID_TOKENICC:
        case ERROR_CODE_INVALID_TOKEN:
            [self refreshTokenAndResendRequest:request];
            break;
        case ERROR_CODE_WECHAT_AUTH_FAILED:
            [self refreshLogin];
            break;
        default:
            [self uploadError:error];
            break;
    }
#ifdef DEBUG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示\n" message:[_errorInfo objectForKey:[NSString stringWithFormat:@"%ld",(long)error.code]] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
#else
#endif

}

/**
 *  重新发送发生错误的请求
 */
- (void)resendRequests {
    if ([_requests count] == 0) {
        return;
    }
    NSArray *pending = [self reencryptRequests:_requests];
    [[RequestScheduler sharedInstance] enqueueRequests:pending];
    [_requests removeAllObjects];
}

#pragma mark -
#pragma mark Resolve Error Methods

/**
 *  对于非微信校验失败、token失效的错误，目前是没办法处理的
 *  所以仅仅把它上传到TD上面，搜集起来
 *
 *  @param error 要上传的错误
 */
- (void)uploadError:(NSError *)error {
    [TalkingDataApi trackEvent:[error domain]
                         label:[@([error code]) stringValue]];
}

/**
 *  刷新token，并且重新发送报错的请求
 *
 *  @param request 报错的请求
 */
- (void)refreshTokenAndResendRequest:(NetworkRequest *_Nullable)request {
//    static long refreshTimestamp = 0; /**< 记录上一次刷新token的时间 */
//    long currentTimestamp = time(NULL);
//    
//    /**
//     * 如果报错的请求和上一次刷新token的时间间隔小于1分钟，
//     * 那么认为是上一次token过期时的请求，
//     * 不需要重新刷新token，只需要重新发送请求即可
//     */
//    if (currentTimestamp - refreshTimestamp > 60) {
//        _oldToken = [[UserManager currentUser] token];
        [self.requests removeAllObjects];
        [self refreshLogin];
//        refreshTimestamp = currentTimestamp;
//    }
//    [self.requests addObject:request];
}

/**
 *  重新登录
 */
- (void)refreshLogin {
    _manager = [[LoginManager alloc] init];
//    _manager.delegate = self;
    [_manager login];
}

#pragma mark -
#pragma mark Re-Encrypt Requests

/**
 *  重新加密一组请求
 *
 *  @param requests 要重新加密的请求数组
 *
 *  @return 重新加密后的一组请求
 */
- (NSArray *_Nonnull)reencryptRequests:(NSArray *)requests {
    NSMutableArray *final = [NSMutableArray arrayWithCapacity:requests.count];
    for (NetworkRequest *request in requests) {
        [final addObject:[self reencryptRequest:request]];
    }
    return [final copy];
}

/**
 *  重新加密一个请求
 *
 *  @param request 要重新加密的请求
 *
 *  @return 重加密后的请求
 */
- (NetworkRequest *)reencryptRequest:(NetworkRequest *)request {
    NSString *newToken = [[UserManager currentUser] token];
    NSString *rawCipherQuery = request.parameters[@"q"];
    NSString *rawQuery = [AES256 decryptString:rawCipherQuery withKey:_oldToken];
    NSString *newCipherQuery = [AES256 encryptString:rawQuery withKey:newToken];
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
    newParams[@"q"] = newCipherQuery;
    request.parameters = [newParams copy];
    return request;
}
@end
