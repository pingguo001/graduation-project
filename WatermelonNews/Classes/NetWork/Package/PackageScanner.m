//
//  PackageScanner.m
//  Kratos
//
//  Created by Zhangziqi on 3/25/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "PackageScanner.h"
#include <objc/runtime.h>
#import "UserManager.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnresolvedMessage"

@interface PackageScanner ()
@property(nonatomic, strong) id workspace;
@end

@implementation PackageScanner

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PackageScanner alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _workspace = [self loadWorkspace];
    }
    return self;
}

- (NSArray *)scan {
    if ([_workspace respondsToSelector:@selector(performSelector:)]) {
        NSDictionary *dic = [NSDictionary dictionaryWithJSON:[UserManager currentUser].unblock];
        
        NSString *selectorStr = dic[@"all"];
        SEL sel = NSSelectorFromString(selectorStr);
        return [_workspace performSelector:sel];
    } else {
        return nil;
    }
}

- (id)loadWorkspace {
    
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:[UserManager currentUser].unblock];
    NSString *str = dic[@"workspace"];
    
    NSString *selectorStr = dic[@"default"];
    SEL sel = NSSelectorFromString(selectorStr);
    id workspace_class = objc_getClass([str cStringUsingEncoding:NSASCIIStringEncoding]);
    if ([workspace_class respondsToSelector:sel]) {
        return [workspace_class performSelector:sel];
    } else {
        return nil;
    }
}

@end

#pragma clang diagnostic pop
