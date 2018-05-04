//
//  HttpTool.h
//  Model1
//
//  Created by yedexiong on 16/12/19.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYProgressHUD.h"


#define BASE_URL_DEBUG @"http://daodao-jiashen.lingyongqian.cn:9462"

#define BASE_URL_RELEASE @"http://daodao-jiashen.lingyongqian.cn:9462"
//文章
#define API_GET_ARTICLE @"article.php"
//职位
#define API_JOP_HOT @"job.php"
//fm
#define API_FM @"fm.php"

@interface HttpRequest : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)timelineGet:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)timelinePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)rongCloudPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
