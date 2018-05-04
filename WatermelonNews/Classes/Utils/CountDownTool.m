//
//  CountDownTool.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/30.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CountDownTool.h"

static dispatch_source_t _timer;

@implementation CountDownTool

#pragma mark - 传入button和倒计时数
+ (void)timeCountDown:(UILabel *)countLabel timeout:(int)time timeoutAction:(TimeoutAction)timeoutAction
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(timeoutAction){
                    timeoutAction(timeout);
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(timeoutAction){
                    timeoutAction(timeout);
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (void)cancelGCDTimer
{
    if (_timer) {
        dispatch_cancel(_timer);
    }
}


@end
