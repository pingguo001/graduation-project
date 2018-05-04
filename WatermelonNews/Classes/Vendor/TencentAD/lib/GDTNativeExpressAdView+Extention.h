//
//  GDTNativeExpressAdView+Extention.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GDTNativeExpressAdView.h"

typedef void(^DeleteBlock)();

@interface GDTNativeExpressAdView (Extention)

@property (copy, nonatomic) DeleteBlock deleteBlock;

@end
