//
//  DetailViewController.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/27.
//  Copyright © 2016年 yoke121. All rights reserved.
//  兼职详情界面

#import <UIKit/UIKit.h>

@class HotModel;

@interface DetailViewController : UIViewController

//首页传递过来的热门职位数据
@property(nonatomic,strong) HotModel *hotmodel;

@end
