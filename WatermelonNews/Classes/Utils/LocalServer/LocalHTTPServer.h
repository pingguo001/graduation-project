//
//  Server.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"
#import "RequestHandler.h"

@interface LocalHTTPServer : HTTPServer
@property (nonatomic, strong) RequestHandler    *handler;
@end
