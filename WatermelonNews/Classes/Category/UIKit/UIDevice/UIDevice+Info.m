//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "UIDevice+Info.h"
#import "Keychain.h"
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"

#include <dlfcn.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (Info)

#pragma -
#pragma mark Advertisement Info

/**
 判断是否开启了 “限制广告跟踪”

 @return 是否开启了限制广告跟踪
 */
- (BOOL)limitAdTrackingEnabled {
    return ![ASIdentifierManager sharedManager].advertisingTrackingEnabled;
}

/**
 *  IDFA
 *
 *  @return IDFA
 */
- (NSString *_Nonnull)idfa {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/**
 *  保存在钥匙串中的IDFA
 *
 *  @return IDFA
 */
- (NSString *_Nonnull)oidfa {
    NSString *key = @"idfa";
    NSString *idfa = [Keychain takeStringValueWithKey:key];
    //如果开启了限制广告跟踪，idfa就是“00000000-0000-0000-0000-000000000000”
    if (idfa == nil || [idfa containsString:@"00000000-"]) {
        idfa = [self idfa];
        //如果拿到不到idfa，改用idfv
        if ([idfa containsString:@"00000000-"]) {
            idfa = [self idfv];
        }
        [Keychain storeStringValue:idfa withKey:key];
    }
    return idfa;
}

/**
 *  IDFV
 *
 *  @return IDFV
 */
- (NSString *_Nonnull)idfv {
    return [[self identifierForVendor] UUIDString];
}

- (NSString *)account{
    
    return [NSString MD5AndSaltString:[[UIDevice currentDevice] oidfa]];
}

#pragma -
#pragma mark Hardware Info

/**
 *  取设备型号标识符，e.g. iPhone8,1
 *
 *  @return 设备型号标识符
 */
- (NSString *_Nonnull)identifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *_Nonnull)cuptype  // 返回CPU类型
{
    size_t size;
    NSMutableString *cpu = [[NSMutableString alloc] init];
    
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);

    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"V7"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"V7s"];
                break;
                // ...
        }
    }
    return cpu;
}

/**
 *  根据设备型号标识符取Board ID，e.g. N71AP
 *
 *  @return Board ID
 */
- (NSString *_Nonnull)boardId {
    NSString *key = @"board_id";
    NSString *boardId = [Keychain takeStringValueWithKey:key];
    if (boardId == nil) {
        NSString *identifier = [self identifier];
        NSString *mapPath = [[NSBundle mainBundle] pathForResource:@"BoardIdMap" ofType:@"plist"];
        NSDictionary *boardDic = [NSDictionary dictionaryWithContentsOfFile:mapPath];
        boardId = [boardDic valueForKey:identifier];
        [Keychain storeStringValue:boardId withKey:@"board_id"];
    }
    return boardId;
}

#pragma -
#pragma mark Wi-Fi Info

/**
 *  SSID
 *
 *  @return SSID
 */
- (NSString *_Nonnull)ssid {
    NSDictionary *en0 = [self en0];
    if (en0 && [en0 count]) {
        return en0[@"SSID"];
    } else {
        return @"NULL";
    }
}

/**
 *  BSSID
 *
 *  @return BSSID
 */
- (NSString *_Nonnull)bssid {
    NSDictionary *en0 = [self en0];
    if (en0 && [en0 count]) {
        return en0[@"BSSID"];
    } else {
        return @"";
    }
}

/**
 *  网卡信息
 *
 *  @return 网卡信息
 */
- (NSDictionary *_Nullable)en0 {
    NSArray *infos = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *info in infos) {
        NSDictionary *en0 = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)info);
        if (en0 && [en0 count]) {
            return en0;
        }
    }
    return nil;
}

/**
 mac地址

 @return mac地址
 */
- (NSString *)macAddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    WNLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

#pragma -
#pragma mark Carrier Info

/**
 *  运营商名字
 *
 *  @return 运营商名字
 */
- (NSString *_Nonnull)carrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName = [carrier carrierName];
    return carrierName == nil ? @"" : carrierName;
}

/**
 *  网络制式
 *
 *  @return 网络制式
 */
- (NSString *_Nonnull)standard{
    NSString *standard = [[CTTelephonyNetworkInfo alloc] init].currentRadioAccessTechnology;
    return standard == nil ? @"" : standard;
}

#pragma mark - 获取网络状态

- (NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    NSString *net = @"wifi";
    
    switch (internetStatus) {
            
        case ReachableViaWiFi:
            
            net = @"WiFi";
            
            break;
            
        case ReachableViaWWAN:
            
            net = @"WWAN";
            
            break;
            
        case NotReachable:
            
            net = @"NotReachable";
            
        default:
            
            break;
            
    }
    
    return net;
    
}

/**
 *  信号强度，获取不到时为-1
 *
 *  @return 信号强度
 */
- (NSNumber *_Nonnull)signalLevel {
    int (*CTGetSignalStrength)();
    void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
    CTGetSignalStrength = (int(*)()) dlsym(libHandle, "CTGetSignalStrength");
    int level = -1;
    if (CTGetSignalStrength != NULL) {
        level = CTGetSignalStrength();
    }
    dlclose(libHandle);
    return [NSNumber numberWithInteger:level];
}


#pragma -
#pragma mark Locale Info

/**
 *  用户设置的国家
 *
 *  @return 国家
 */
- (NSString *_Nonnull)country {
    // 当前所在地信息
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    NSString *country = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:locale];
    return country;
}

/**
 *  用户设置国家的代码
 *
 *  @return 国家代码
 */
- (NSString *_Nonnull)countryCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

/**
 *  用户设置的语言
 *
 *  @return 语言
 */
- (NSString *_Nonnull)language {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}

#pragma -
#pragma mark Screen Info

/**
 *  屏幕的高
 *
 *  @return 屏幕的高
 */
- (NSNumber *_Nonnull)screenHeight {
    return [NSNumber numberWithFloat:[self screenRect].size.height * [[self screenScale] floatValue]];
}

/**
 *  屏幕的宽
 *
 *  @return 屏幕的宽
 */
- (NSNumber *_Nonnull)screenWidth {
    return [NSNumber numberWithFloat:([self screenRect].size.width  * [[self screenScale] floatValue])];
}

/**
 *  屏幕的Rect
 *
 *  @return 屏幕的Rect
 */
- (CGRect)screenRect {
    return [[UIScreen mainScreen] bounds];
}

/**
 *  屏幕缩放比例
 *
 *  @return 屏幕缩放比例
 */
- (NSNumber *_Nonnull)screenScale {
    return [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]];
}

#pragma -
#pragma mark Battery Info

/**
 *  电池信息，包含电量和充电状态
 *
 *  @return 电池信息
 */
- (NSDictionary *_Nonnull)batteryInfos {
    [self setBatteryMonitoringEnabled:YES];

    NSNumber *level = [NSNumber numberWithFloat:self.batteryLevel];
    NSString *state = nil;
    
    if (self.batteryState == UIDeviceBatteryStateUnknown) {
        state = @"UNKNOWN";
    } else if (self.batteryState == UIDeviceBatteryStateUnplugged){
        state = @"UNPLUGGED";
    } else if (self.batteryState == UIDeviceBatteryStateCharging){
        state = @"CHARGING";
    } else if (self.batteryState == UIDeviceBatteryStateFull){
        state = @"FULL";
    } else {
        state = @"NONE";
    }
    
    return @{
             @"batteryLevel" : level,
             @"batteryState" : state
             };
}

/**
 *  电池ID，iOS 8以上可用
 *
 *  @return 电池ID
 */
- (NSString *_Nonnull)batteryId {
    void *ioKit = dlopen("/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit", RTLD_LAZY);
    if (ioKit == nil) {
        return @"";
    }
    
    mach_port_t *kIOMasterPortDefault = dlsym(ioKit, "kIOMasterPortDefault");
    if (kIOMasterPortDefault == nil) {
        return @"";
    }
    
    CFMutableDictionaryRef (*IOServiceNameMatching)(const char *name) = dlsym(ioKit, "IOServiceNameMatching");
    if (IOServiceNameMatching == nil) {
        return @"";
    }
    
    mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(ioKit, "IOServiceGetMatchingService");
    if (IOServiceGetMatchingService == nil) {
        return @"";
    }
    
    kern_return_t (*IORegistryEntryCreateCFProperties)(mach_port_t entry, CFMutableDictionaryRef *properties, CFAllocatorRef allocator, UInt32 options) = dlsym(ioKit, "IORegistryEntryCreateCFProperties");
    if (IORegistryEntryCreateCFProperties == nil) {
        return @"";
    }
    
    kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(ioKit, "IOObjectRelease");
    
    if (IOObjectRelease == nil) {
        return @"";
    }
    
    CFMutableDictionaryRef properties = NULL;
    
    mach_port_t service = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceNameMatching("charger"));
    IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0);
    
    IOObjectRelease(service);
    service = 0;
    
    NSDictionary *dictionary = (__bridge NSDictionary *)properties;
    NSData *batteryIDData = [dictionary objectForKey:@"battery-id"];
    
    CFRelease(properties);
    properties = NULL;
    
    dlclose(ioKit);
    
    return batteryIDData == nil ? @"" : [NSString stringWithUTF8String:[batteryIDData bytes]];
}


- (NSString *_Nonnull)timestamp {
    return [NSString stringWithFormat:@"%ld", (long) [[NSDate date] timeIntervalSince1970]];
}

@end
