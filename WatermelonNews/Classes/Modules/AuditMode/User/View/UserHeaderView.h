//
//  UserHeaderView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

typedef void(^ButtonBlock)(NSInteger index);

#define kImgHeight (adaptHeight1334(428) - 64)

@interface UserHeaderView : UIImageView

@property (copy, nonatomic) ButtonBlock buttonBlock;

- (void)setUserIsLogin:(BOOL)isLogin;

@end
