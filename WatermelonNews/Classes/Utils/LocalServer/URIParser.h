//
//  URIParser.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URIParser : NSObject

- (NSString *_Nullable)parseOperFromUri:(NSString *_Nonnull)uri;

- (NSDictionary *_Nullable)parseQueryFromUri:(NSString *_Nonnull)uri;

@end
