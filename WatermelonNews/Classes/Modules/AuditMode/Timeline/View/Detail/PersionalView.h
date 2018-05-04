//
//  PersionalView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/7.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

#define kPersionalHeight adaptHeight1334(430)

@interface PersionalView : UIImageView

@property (strong, nonatomic) UIButton *editButton;

- (void)configHeadImage:(NSString *)headImage;
- (void)configNickname:(NSString *)nickname;

@end
