//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "NSString+Split.h"

@implementation NSString (Split)

- (NSMutableArray *)splitToChars {
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
    for (NSUInteger i = 0; i < [self length]; i++) {
        NSString *ichar = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        [characters addObject:ichar];
    }
    return characters;
}

+ (NSString *)reverseWordsInString:(NSString *)oldStr{
    
    NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:oldStr.length];
    
    for (int i = (int)oldStr.length - 1; i >= 0; i --) {
        
        unichar character = [oldStr characterAtIndex:i];

        [newStr appendFormat:@"%c",character];
        
    }
    return newStr;
}

@end
