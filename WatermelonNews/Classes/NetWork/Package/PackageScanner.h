//
//  PackageScanner.h
//  Kratos
//
//  Created by Zhangziqi on 3/25/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageScanner : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)scan;
@end