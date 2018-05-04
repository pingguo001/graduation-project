//
//  CountDownTool.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/30.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimeoutAction)(int time);

@interface CountDownTool : NSObject

+ (void)timeCountDown:(UILabel *)countLabel timeout:(int)time timeoutAction:(TimeoutAction)timeoutAction;

@end