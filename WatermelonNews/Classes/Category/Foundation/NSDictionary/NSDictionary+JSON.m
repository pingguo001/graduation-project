//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "NSDictionary+JSON.h"


@implementation NSDictionary (JSON)

- (instancetype _Nullable)initWithJSON:(NSString *_Nonnull)json {
    if (json== nil) {
        return @{};
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithDictionary:[NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil]];
}

+ (instancetype _Nullable)dictionaryWithJSON:(NSString *_Nonnull)json {
    return [[NSDictionary alloc] initWithJSON:json];
}

- (NSString *_Nullable)json {
    return [self jsonWithError:nil];
}

- (NSString *_Nullable)jsonWithError:(NSError **_Nullable)error {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
