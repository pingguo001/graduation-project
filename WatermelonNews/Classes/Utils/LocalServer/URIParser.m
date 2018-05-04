//
//  URIParser.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/14.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "URIParser.h"

@implementation URIParser

- (NSString *_Nullable)parseOperFromUri:(NSString *_Nonnull)uri {
    NSArray *splitStrings = [uri componentsSeparatedByString:@"?"];
    
    if (splitStrings == nil || splitStrings.count == 0) {
        return nil;
    } else {
        NSString *oper = splitStrings[0];
        if ([oper hasPrefix:@"/"] && [oper length] > 1) {
            oper = [oper substringFromIndex:1];
        }
        return oper;
    }
}

- (NSDictionary *_Nullable)parseQueryFromUri:(NSString *_Nonnull)uri {
    NSArray *splitStrings = [uri componentsSeparatedByString:@"?"];
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionaryWithCapacity:10];
    if (splitStrings == nil || splitStrings.count < 2) {
        return nil;
    } else {
        NSString *allQueryString = splitStrings[1];
        NSArray *allQueryArray = [allQueryString componentsSeparatedByString:@"&"];
        for (NSString *queryString in allQueryArray) {
            NSArray* queryArray = [queryString componentsSeparatedByString:@"="];
            [queryDic setObject:queryArray[1] forKey:queryArray[0]];
        }
        return queryDic;
    }
}

@end
