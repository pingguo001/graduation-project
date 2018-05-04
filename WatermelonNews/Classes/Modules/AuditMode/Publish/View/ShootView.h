//
//  ShootView.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol ShootViewDelegate <NSObject>

- (void)shootAction;
- (void)closeAction;
- (void)cancleAction;
- (void)sureAction;
- (void)focusingActionAtPoint:(CGPoint)point;

@end

@interface ShootView : BaseView

@property (weak, nonatomic) id<ShootViewDelegate> delegate;

//拍照完成
- (void)shootComplete;

@end
