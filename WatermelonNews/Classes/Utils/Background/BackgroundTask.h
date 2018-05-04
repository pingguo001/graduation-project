//
// Created by Zhangziqi on 3/22/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTask : NSObject
- (void)startBackgroundTasks:(NSInteger)time target:(id)target selector:(SEL)sel;
- (void)stopBackgroundTask;
@end