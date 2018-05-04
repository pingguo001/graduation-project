//
//  TabHeaderView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol TabHeaderViewDelegate <NSObject>

- (void)didSelectTabIndex:(NSInteger)index;
- (void)didRefreshClickIndex:(NSInteger)index;

@end

@interface TabHeaderView : BaseView

- (void)cofigureDelegate:(id<TabHeaderViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray withMultiple:(CGFloat)multiple;

- (void)selectTabIndex:(NSInteger)index;

@end
