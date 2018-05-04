//
//  Jailbroken.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/12.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "Jailbroken.h"
#import <sys/stat.h>
#import <dlfcn.h>

NSString * const cydia = @"/Applications/Cydia.app";
NSString * const mobileSubstrate = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
NSString * const bash = @"/bin/bash";
NSString * const sshd = @"/usr/sbin/sshd";
NSString * const apt = @"/etc/apt";

const char *kernel_lib = "/usr/lib/system/libsystem_kernel.dylib";
const char *env_insert_lib = "DYLD_INSERT_LIBRARIES";

@implementation Jailbroken

+ (void)detect:(int *)res {
    detect(*res);
}

void detect(int &res) {
    detectMalwareFiles(res);
    detectCydia(res);
    detectInjectLib(res);
    detectEnv(res);
}

void detectMalwareFiles(int &res) {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:cydia]) {
        res++;
    }
    if ([manager fileExistsAtPath:mobileSubstrate]) {
        res++;
    }
    if ([manager fileExistsAtPath:bash]) {
        res++;
    }
    if ([manager fileExistsAtPath:sshd]) {
        res++;
    }
    if ([manager fileExistsAtPath:apt]) {
        res++;
    }
}

void detectCydia(int &res) {
    const char *cydia_cstr = [cydia cStringUsingEncoding:NSASCIIStringEncoding];
    struct stat stat_info;
    int stat_res = stat(cydia_cstr, &stat_info);
    if (stat_res == 0) {
        res++;
    }
}

void detectInjectLib(int &res) {
    int ret ;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(&func_stat, &dylib_info))) {
        if (strcmp(kernel_lib, dylib_info.dli_fname) != 0) {
            res++;
        }
    }
}

void detectEnv(int &res) {
    char *env = getenv(env_insert_lib);
    if (env != NULL) {
        res++;
    }
}
@end
