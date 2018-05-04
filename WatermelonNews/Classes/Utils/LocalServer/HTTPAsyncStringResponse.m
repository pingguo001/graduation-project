//
//  HTTPAsyncResponse.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "HTTPAsyncStringResponse.h"

@interface HTTPAsyncStringResponse ()
@property (nonatomic, assign) BOOL              isReady;
@property (nonatomic, weak)   HTTPConnection    *connection;
@end

@implementation HTTPAsyncStringResponse

+ (instancetype _Nonnull)responseWithConnection:(HTTPConnection *_Nonnull)connection {
    return [[HTTPAsyncStringResponse alloc] initWithHTTPConnection:connection];
}

- (instancetype _Nonnull)initWithHTTPConnection:(HTTPConnection *_Nonnull)connection {
    self = [super init];
    if (self) {
        _offset = 0;
        _isReady = NO;
        _isChunked = YES;
        _connection = connection;
    }
    return self;
}

- (void)setResponse:(NSString *)response {
    _response = response;
    _isReady = YES;
    [_connection responseHasAvailableData:self];
}

- (UInt64)contentLength {
    return _isReady ? [_response length] : 0;
}

- (BOOL)isChunked {
    return _isChunked;
}

- (NSData *)readDataOfLength:(NSUInteger)length {
    return _isReady ? [_response dataUsingEncoding:NSUTF8StringEncoding] : nil;
}

- (BOOL)isDone {
    return _isReady;
}

- (NSDictionary *)httpHeaders {
    return _headers;
}

@end
