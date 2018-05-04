//
//  ContentView.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView

-(instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray*)childViewControllers  parentVC:(UIViewController*)parentVC;

// 让子视图滚动到指定位置
-(void)scrollToIndex:(NSInteger)index;

@end
