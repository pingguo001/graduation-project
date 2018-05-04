//
//  TaskMonitor.m
//  Kratos
//
//  Created by Zhangziqi on 27/10/2016.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "TaskMonitor.h"
#import "PackageManager.h"
#import "ProcessManager.h"

#define INTERVAL_MONITOR   30    /**< 检测间隔为5秒 */
#define MAX_FIRE_COUNT     20    /**< 最大检测次数为60 */

@interface TaskMonitor ()
@property (nonnull, strong) NSTimer *timer;         /**< 定时器，触发检测 */
@property (nonnull, copy)   NSString *bundleId;     /**< 要检测的包名 */
@property (assign)          NSInteger fireCount;    /**< 定时器触发次数 */
@end

@implementation TaskMonitor

#pragma -
#pragma mark Initialize

/**
 初始化

 @return 实例对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupTimer];
        _fireCount = 0;
    }
    return self;
}

- (void)setupTimer {
    _timer = [NSTimer timerWithTimeInterval:INTERVAL_MONITOR
                                     target:self
                                   selector:@selector(onTimerFire)
                                   userInfo:nil
                                    repeats:YES];
    
    // 确保timer被附加到主进程上
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSRunLoop currentRunLoop] addTimer:_timer
                                     forMode:NSDefaultRunLoopMode];
    });
}

#pragma -
#pragma mark Public Methods

/**
 开始监听指定的App

 @param bundleId 要监听的包名
 */
- (void)startWithBundleId:(NSString *_Nonnull)bundleId {
    
    NSLog(@"start monitor, bundle id : %@", bundleId);
    
//    if (_bundleId != nil &&
//        [_bundleId isEqualToString:bundleId]) {
//        return;
//    }
    
    _bundleId = bundleId;
    [_timer setFireDate:[NSDate distantPast]];
    
    NSLog(@"timer has been set");
}

#pragma -
#pragma mark Private Methods

/**
 定时器触发的回调
 */
- (void)onTimerFire {
    
    NSLog(@"timer fired");
    
    if (_fireCount > MAX_FIRE_COUNT) {
        _fireCount = 0;

        [_timer setFireDate:[NSDate distantFuture]];
    } else {
        _fireCount++;
        if ([PackageManager isAppInstalled:_bundleId] &&
            [PackageManager openApp:_bundleId]) {
            NSLog(@"open app successed, fire count reset");
            [_timer setFireDate:[NSDate distantFuture]];
            [[ProcessManager sharedInstance] uploadProcess:_bundleId]; //上传进程
            _fireCount = 0;
            _bundleId = nil;
        }
    }
}

@end
