//
//  GDTNativeExpressAdView+Extention.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "GDTNativeExpressAdView+Extention.h"

static const void *kBlock = "block";

@implementation GDTNativeExpressAdView (Extention)

- (void)setDeleteBlock:(DeleteBlock)deleteBlock
{
    objc_setAssociatedObject(self, kBlock, deleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (DeleteBlock)deleteBlock
{
    return objc_getAssociatedObject(self, kBlock);
}

@end
