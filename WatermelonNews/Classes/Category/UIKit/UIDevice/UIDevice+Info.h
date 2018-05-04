//
// Created by Zhangziqi on 4/14/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (Info)

- (BOOL)limitAdTrackingEnabled;
- (NSString *_Nonnull)idfa;
- (NSString *_Nonnull)oidfa;
- (NSString *_Nonnull)idfv;
- (NSString *_Nullable)account;

- (NSString *_Nonnull)identifier;
- (NSString *_Nonnull)cuptype;
- (NSString *_Nonnull)boardId;

- (NSString *_Nonnull)ssid;
- (NSString *_Nonnull)bssid;
- (NSString *_Nullable)macAddress;

- (NSString *_Nonnull)carrierName;
- (NSString *_Nonnull)standard;
- (NSString *_Nullable)internetStatus;
- (NSNumber *_Nonnull)signalLevel;

- (NSString *_Nonnull)country;
- (NSString *_Nonnull)countryCode;
- (NSString *_Nonnull)language;

- (NSNumber *_Nonnull)screenHeight;
- (NSNumber *_Nonnull)screenWidth;
- (NSNumber *_Nonnull)screenScale;

- (NSDictionary *_Nonnull)batteryInfos;
- (NSString *_Nonnull)batteryId;

- (NSString *_Nonnull)timestamp;
@end
