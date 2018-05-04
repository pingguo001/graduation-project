//
//  TitleView.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleViewH 35

@class TitleView;
@protocol TitleViewDataSource <NSObject>

@required
//标题内容
-(NSArray*)showTitlesWithtitleView:(TitleView*)titleView;

@optional
//选中标题
-(void)titleView:(TitleView*)titleView selectIndex:(NSInteger)index;

@end

@interface TitleView : UIView

@property(nonatomic,weak)id <TitleViewDataSource> dataSource;


//刷新标题数据
-(void)reloadData;

//选中指定索引的按钮
-(void)selectIndex:(NSInteger)Index;


@end
