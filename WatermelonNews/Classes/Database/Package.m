//
//  Package.m
//  Kratos
//
//  Created by Zhangziqi on 3/28/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "Package.h"
#import <objc/runtime.h>

@implementation Package

#pragma -
#pragma initiliaze

+ (instancetype)initWithBundleId:(NSString *)bundleId
                bundleExecutable:(NSString *)bundleExecutable {
    Package *package = [[Package alloc] init];
    [package setBundleId:bundleId];
    [package setBundleExecutable:bundleExecutable];
    return package;
}

+ (instancetype)initWithProxy:(id)proxy {
    
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:[UserManager currentUser].unblock];
    
    Class proxyClass = objc_getClass([dic[@"prox"] cStringUsingEncoding:NSASCIIStringEncoding]);
    if (![proxy isKindOfClass:proxyClass]) {
        return nil;
    }

    NSString *bundleExecutable;
    NSString *bundleId;
    BOOL     isPlaceholder;
    
    NSString *selectorStr = dic[@"identifier"];
    SEL sel = NSSelectorFromString(selectorStr);

    if ([proxy respondsToSelector:sel]) {
        bundleId = [proxy performSelector:sel];
    }

    if ([proxy respondsToSelector:@selector(bundleExecutable)]) {
        bundleExecutable = [proxy performSelector:@selector(bundleExecutable)];
    }
    
    if ([proxy respondsToSelector:@selector(isPlaceholder)]) {
        isPlaceholder = [proxy performSelector:@selector(isPlaceholder)];
    }

    Package *package = [[Package alloc] init];

    [package setBundleId:bundleId];
    [package setBundleExecutable:bundleExecutable];
    [package setIsPlaceholder:isPlaceholder];

    return package;
}

+ (instancetype)initWithDictionary:(NSDictionary *)dic {
    Package *package = [[Package alloc] init];
    [package setBundleId:dic[@"bundle_id"]];
    [package setBundleExecutable:dic[@"bundle_executable"]];
    return package;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Package> {bundleId : %@, bundle_executable : %@}", self.bundleId, self.bundleExecutable];
}

@end
