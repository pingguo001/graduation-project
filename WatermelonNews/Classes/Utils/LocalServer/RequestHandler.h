//
//  RequestHandler.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPResponse;
@class HTTPConnection;

@interface RequestHandler : NSObject

- (instancetype _Nonnull)initWithConnection:(HTTPConnection *_Nonnull)connection;

- (BOOL)isKnownOper:(NSString *_Nullable)oper;

- (NSObject <HTTPResponse> *_Nullable)handleRequest:(NSString *_Nonnull)oper
                                              query:(NSDictionary *_Nonnull)query;
@end
