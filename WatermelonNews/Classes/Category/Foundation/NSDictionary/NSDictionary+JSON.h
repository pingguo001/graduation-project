//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (instancetype _Nullable)initWithJSON:(NSString *_Nonnull)json;

+ (instancetype _Nullable)dictionaryWithJSON:(NSString *_Nonnull)json;

- (NSString *_Nullable)json;

- (NSString *_Nullable)jsonWithError:(NSError *_Nullable *_Nullable)error;

@end