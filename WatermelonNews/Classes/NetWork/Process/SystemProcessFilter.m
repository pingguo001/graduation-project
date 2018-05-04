//
//  Filter.m
//  Kratos
//
//  Created by Zhangziqi on 3/24/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "SystemProcessFilter.h"

@interface SystemProcessFilter ()


@end

@implementation SystemProcessFilter

- (NSArray *_Nonnull)filterData:(NSArray *_Nonnull)data {
    NSMutableSet *raw = [NSMutableSet setWithArray:data];
    [raw minusSet:[self defaultProcesses]];
    return [raw allObjects];
}

- (NSSet *_Nonnull)defaultProcesses {
    return [NSSet setWithObjects:@"kernel_task", @"UserEventAgent",
                                 @"syslogd", @"powerd", @"lockdownd", @"mediaserverd",
                                 @"mediaremoted", @"mDNSResponder", @"locationd",
                                 @"imagent", @"iapd", @"fseventsd", @"fairplayd.N81",
                                 @"configd", @"apsd", @"aggregated", @"SpringBoard",
                                 @"CommCenterClassi", @"BTServer", @"notifyd",
                                 @"MobilePhone", @"ptpd", @"afcd", @"notification_pro",
                                 @"notification_pro", @"syslog_relay", @"springboardservi",
                                 @"atc", @"sandboxd", @"networkd", @"lsd", @"securityd",
                                 @"lockbot", @"installd", @"debugserver", @"amfid",
                                 @"AppleIDAuthAgent", @"BootLaunch", @"MobileMail",
                                 @"BlueTool", @"timed", @"iaptransportd", @"backboardd",
                                 @"sharingd", @"routined", @"assistantd", @"aosnotifyd",
                                 @"keybagd", @"ubd", @"identityservices", @"fairplayd.H2",
                                 @"vmd", @"wirelessproxd", @"MobileGestaltHel", @"mstreamd",
                                 @"distnoted", @"WirelessCoexMana", @"networkd_privile",
                                 @"accountsd", @"itunesstored", @"DuetLST", @"pfd", @"pkd",
                                 @"EscrowSecurityAl", @"dataaccessd", @"tccd", @"touchsetupd",
                                 @"kbd", @"mobileassetd", @"librariand", @"filecoordination",
                                 @"com.apple.Stream", @"limitadtrackingd", @"medialibraryd",
                                 @"itunescloudd", @"xpcd", @"com.apple.facebo", @"sbd",
                                 @"com.apple.lakitu", @"storebookkeeperd", @"adid", @"Music",
                                 @"CloudKeychainPro", @"softwareupdatese", @"assetsd",
                                 @"geod", @"absd", @"mobile_assertion", @"mobile_installat",
                                 @"softwarebehavior", @"CMFSyncAgent", @"coresymbolicatio",
                                 @"safarifetcherd", @"IMDPersistenceAg", @"recentsd",
                                 @"webbookmarksd", @"calaccessd", @"XcodeDeviceMonit",
                                 @"assistant_servic", @"syncdefaultsd", @"AngelFace",
                                 @"CommCenter", @"pasteboardd", @"StoreKitUIServic",
                                 @"BTLEServer", @"MobileSafari", @"backupd", @"deleted",
                                 @"CFNetworkAgent", @"SiriViewService", @"AppStore",
                                 @"fileproviderd", @"misd", @"familynotificati", @"uchd",
                                 @"softwareupdated", @"awdd", @"discoveryd", @"SCHelper",
                                 @"askpermissiond", @"assertiond", @"tipsd", @"assistiveto",
                                 @"cfprefsd", @"WirelessRadioMan", @"mobactivationd",
                                 @"profiled", @"discoveryd_helpe", @"coreduetd", @"oscard",
                                 @"nsurlstoraged", @"com.apple.Mobile", @"containermanager",
                                 @"mediaartworkd", @"nehelper", @"misagent", @"callservicesd",
                                 @"DuetHeuristic-BM", @"nsurlsessiond", @"MicroMessenger",
                                 @"AGXCompilerServi", @"biometrickitd", @"findmydeviced",
                                 @"diagnosticd", @"swcd", @"bird", @"AssetCacheLocato",
                                 @"CallHistorySyncH", @"languageassetd", @"cplogd",
                                 @"passd", @"fmfd", @"in", @"homed", @"suggestd", @"wifid",
                                 @"lsuseractivityd", @"com.apple.sbd", @"lskdd",
                                 @"InCallService", @"gamed", @"com.apple.uifoun",
                                 @"CalendarWidget", @"voicememod", @"CacheDeleteITune",
                                 @"CacheDeleteAppCo", @"CacheDeleteMobil",
                                 @"streaming_zip_co", @"familycircled", @"Xiaoqin",
                                 @"MessagesNotifica", @"healthd", @"coreauthd",
                                 @"com.sogou.sogoui", @"DTMobileIS", @"MobileStorageMou",
                                 @"MobileStorageMou", @"rtcreportingd", @"StocksWidget",
                                 @"vsassetd", @"CacheDeleteGeoTi", @"revisiond",
                                 @"MobileCal", @"reversetemplated", @"ContainerMetadat",
                                 @"ind", @"DTPower", @"pipelined", @"MobileSMS",
                                 @"Preferences", @"cloudphotod", @"searchd",
                                 @"seld", @"CacheDeleteSyste", @"com.apple.WebKit",
                                 @"SafariViewServic", @"splashboardd", nil];
}
@end