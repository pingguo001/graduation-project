//
//  HTTPAsyncResponse.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponse.h"
#import "HTTPConnection.h"

@interface HTTPAsyncStringResponse : NSObject <HTTPResponse>

@property (nonatomic, strong, nullable) NSString *response;
@property (nonatomic, strong, nullable) NSDictionary *headers;
@property (nonatomic, assign)           UInt64   offset;
@property (nonatomic, assign)           BOOL     isChunked;

+ (instancetype _Nonnull)responseWithConnection:(HTTPConnection *_Nonnull)connection;

- (instancetype _Nonnull)initWithHTTPConnection:(HTTPConnection *_Nonnull)connection;

@end
