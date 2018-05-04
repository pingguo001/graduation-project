//
//  Server.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "LocalHTTPServer.h"
#import "LocalHTTPConnection.h"

#define WEB_ROOT [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"]

@implementation LocalHTTPServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setType:@"_http._tcp."];
        [self setPort:9527];
        [self setDocumentRoot:WEB_ROOT];
        [self setConnectionClass:[LocalHTTPConnection class]]; //设置自定义请求响应
    }
    return self;
}

@end
