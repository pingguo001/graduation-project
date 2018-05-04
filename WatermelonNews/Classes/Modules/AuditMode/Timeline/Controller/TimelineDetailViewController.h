//
//  TimelineDetailViewController.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineModel.h"

typedef void(^RefreshBlock)();
@interface TimelineDetailViewController : UITableViewController

@property (strong, nonatomic) TimelineModel *userModel;
@property (copy, nonatomic) RefreshBlock refreshBlock;

@end
