//
//  PublishViewController.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineModel.h"

@interface PublishViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) TimelineModel *timelineModel;

/**
 是否是转发文章
 */
@property (assign, nonatomic) BOOL isOnlyText;

@end
