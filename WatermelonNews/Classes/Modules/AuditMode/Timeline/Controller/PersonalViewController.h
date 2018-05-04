//
//  PersonalViewController.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalViewController : UITableViewController

@property (copy, nonatomic) NSString *userInfo;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nickName;

@property (assign, nonatomic) BOOL isMyself;

@end
