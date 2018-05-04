//
//  NSURL+Split.m
//  Kratos
//
//  Created by Zhangziqi on 9/1/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "NSURL+Split.h"

@implementation NSURL (Split)

- (NSDictionary *_Nullable)queryDictionary {
    NSArray<NSURLQueryItem *> *items = [self queryItems];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:items.count];
    for (NSURLQueryItem *item in items) {
        [dictionary setObject:item.value forKey:item.name];
    }
    
    return [dictionary copy];
}

- (NSArray *_Nullable)queryItems {
    return [[NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO] queryItems];
}

- (NSString *_Nullable)queryItemForKey:(NSString *_Nonnull)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSArray *filterdItems = [[self queryItems] filteredArrayUsingPredicate:predicate];
    if (filterdItems == nil || filterdItems.count == 0) {
        return nil;
    }
    NSURLQueryItem *filterdItem = [filterdItems firstObject];
    return filterdItem.value;
}

@end
