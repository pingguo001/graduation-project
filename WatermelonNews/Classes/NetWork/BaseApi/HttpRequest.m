//
//  HttpTool.m
//  Model1
//
//  Created by yedexiong on 16/12/19.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

//设置超时时间为10s
static NSInteger const KTimeoutInterval = 15;

@implementation HttpRequest

+(AFHTTPSessionManager *)instanceMgr
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = KTimeoutInterval;
    
    return mgr;
}

//拼接链接
+(NSString*)appendFullUrlWithUrl:(NSString*)url

{
#ifdef DEBUG
   return [BASE_URL_DEBUG stringByAppendingPathComponent:url];
#else
   return [BASE_URL_RELEASE stringByAppendingPathComponent:url];
#endif
    
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [self instanceMgr];
    //2、拼接链接
   NSString *fullUrl = [self appendFullUrlWithUrl:url];
    //3、发送请求
   [mgr GET:fullUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id json;
            if ([responseObject isKindOfClass:NSData.class]) {
               json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                json = responseObject;
            }
            success(json);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [self instanceMgr];
    //2、拼接链接
    NSString *fullUrl = [self appendFullUrlWithUrl:url];
    //3、发送请求
    [mgr POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id json;
            if ([responseObject isKindOfClass:NSData.class]) {
                json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                json = responseObject;
            }
            success(json);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)timelineGet:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [self instanceMgr];
    //3、发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id json;
            if ([responseObject isKindOfClass:NSData.class]) {
                json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                json = responseObject;
            }
            success(json);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)timelinePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [self instanceMgr];
    //3、发送请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id json;
            if ([responseObject isKindOfClass:NSData.class]) {
                json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                json = responseObject;
            }
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)rongCloudPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [self instanceMgr];
    
    NSString *appKey = @"y745wfm8y7vtv"; // 开发者平台分配的 App key。
    NSString *appSecret = @"71dNbc3zml"; // 开发者平台分配的 App Secret。
    NSString *nonce = [NSString stringWithFormat:@"%u", arc4random() % 1000000]; // 获取随机数。
    NSString *timestamp = [NSString stringWithFormat:@"%ld", time(0)]; // 获取时间戳。
    NSString *signature = [NSString sha1:[[appSecret stringByAppendingString:nonce] stringByAppendingString:timestamp]];
    
    [mgr.requestSerializer setValue:appKey forHTTPHeaderField:@"App-Key"];
    [mgr.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [mgr.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [mgr.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

    //3、发送请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id json;
            if ([responseObject isKindOfClass:NSData.class]) {
                json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }else{
                json = responseObject;
            }
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
