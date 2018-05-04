//
//  LocalHTTPConnection.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "LocalHTTPConnection.h"
#import "RequestHandler.h"
#import "URIParser.h"

@interface LocalHTTPConnection()
@property (nonatomic, strong) RequestHandler    *handler;
@property (nonatomic, strong) URIParser         *uriParser;
@end

@implementation LocalHTTPConnection

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
    if (self = [super initWithAsyncSocket:newSocket configuration:aConfig]) {
        _handler = [[RequestHandler alloc] initWithConnection:self];
        _uriParser = [[URIParser alloc] init];
    }
    return self;
}

/**
 *  处理请求
 *
 *  @param method 请求方式
 *  @param uri    请求uri
 *
 *  @return 响应
 */
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method
                                              URI:(NSString *)uri {
    NSString *oper = [_uriParser parseOperFromUri:uri];
    
    if (![_handler isKnownOper:oper]) {
        return [super httpResponseForMethod:method URI:uri];
    } else {
        NSDictionary *query = [_uriParser parseQueryFromUri:uri];
        return [_handler handleRequest:oper query:query];
    }
}

@end
