//
//  NewsListViewController.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCategoryModel.h"

@interface NewsListViewController : UITableViewController

@property (strong, nonatomic) NewsCategoryModel *categoryModel;
@property (strong, nonatomic) UIView *loadingView;

@end
