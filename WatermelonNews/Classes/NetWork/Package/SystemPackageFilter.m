//
//  SystemPackageFilter.m
//  Kratos
//
//  Created by Zhangziqi on 3/24/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "SystemPackageFilter.h"

@implementation SystemPackageFilter

+ (NSArray *_Nonnull)filterData:(NSSet *_Nonnull)data {
    NSMutableSet *raw = [data mutableCopy];
    [raw minusSet:[self defaultPackages]];
    return [raw allObjects];
}

+ (NSSet *_Nonnull)defaultPackages {
    return [NSSet setWithObjects:
            @"com.apple.DemoApp", @"com.apple.camera", @"com.apple.mobilemail",
            @"com.apple.WebSheet", @"com.apple.AdSheetPhone", @"com.apple.AppStore",
            @"com.apple.fieldtest", @"com.apple.Preferences",
            @"com.apple.AccountAuthenticationDialog", @"com.apple.uikit.PrintStatus",
            @"com.apple.social.remoteui.SocialUIService",
            @"com.apple.MobileAddressBook", @"com.apple.iosdiagnostics",
            @"com.apple.gamecenter.GameCenterUIService",
            @"com.apple.mobiletimer", @"com.apple.Music",
            @"com.apple.MobileSMS", @"com.apple.DataActivation",
            @"com.apple.Photo-Booth", @"com.apple.TencentWeiboAccountMigrationDialog",
            @"com.apple.webapp", @"com.apple.reminders", @"com.apple.iad.iAdOptOut",
            @"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
            @"com.apple.datadetectors.DDActionsService", @"com.apple.SiriViewService",
            @"com.apple.WebViewService", @"com.apple.Maps", @"com.apple.mobilesms.compose",
            @"com.apple.TrustMe", @"com.apple.FacebookAccountMigrationDialog",
            @"com.apple.videos", @"com.asou.AngelFace", @"com.apple.mobileslideshow",
            @"com.apple.purplebuddy", @"com.apple.facetime", @"com.apple.mobilecal",
            @"com.apple.MailCompositionService", @"com.apple.gamecenter",
            @"com.apple.CompassCalibrationViewService", @"com.apple.ios.StoreKitUIService",
            @"com.apple.mobilenotes", @"com.apple.MusicUIService",
            @"com.apple.appleaccount.AACredentialRecoveryDialog",
            @"com.apple.mobilesafari", @"com.apple.quicklook.quicklookd",
            @"com.apple.MobileStore", @"com.apple.MobileReplayer", nil];
}
@end