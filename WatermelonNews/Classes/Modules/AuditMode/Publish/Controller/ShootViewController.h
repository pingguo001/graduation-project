//
//  ShootView.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockImage)(UIImage *image);

@interface ShootViewController : UIViewController

@property (copy, nonatomic) BlockImage blcokImage;

@end
