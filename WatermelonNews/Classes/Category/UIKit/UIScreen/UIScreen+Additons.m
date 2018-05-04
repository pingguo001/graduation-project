//
//  UIScreen+Additons.m
//  TestDemo
//
//  Created by 刘永杰 on 2017/6/13.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UIScreen+Additons.h"

@implementation UIScreen (Additons)

//宽度自适应
+ (float)numberFromWidth750:(float)number
{
    if (number * kScreenHeight / 750.0f < 0.85) {
        return 0.5;
    }
    if (kScreenWidth <= 320) {
        return number * 375 / 750.0f;
    }
    return number * kScreenWidth / 750.0f;
}

//高度自适应
+ (float)numberFromHeight1334:(float)number
{
    if (kScreenHeight <= 568) {
        return number * 667 / 1334.0f;
    } // 5s与6使用同一套
    return ((number * kScreenHeight) / 1334.0f);
}

+ (float)numberFromNormalHeight1334:(float)number
{
    return ((number * kScreenHeight) / 1334.0f);
}

/** 字体大小  可以根据UI需要修改*/
+ (float)numberFontSize:(float)number
{
    if (kScreenHeight <= 568) {
        return number * 667 / 1334.0f;
    } // 5s与6使用同一套
    return ((number * kScreenHeight) / 1334.0f);
}

@end
