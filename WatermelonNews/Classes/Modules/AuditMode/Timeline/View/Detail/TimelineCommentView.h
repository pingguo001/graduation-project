//
//  BottomCommentView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol TimelineCommentViewDelegate  <NSObject>

- (void)didClickCommentViewIndex:(NSInteger)index;

@end

@interface TimelineCommentView : BaseView

@property (weak, nonatomic) id<TimelineCommentViewDelegate>delegate;
@property (strong, nonatomic) UIButton *praiseButton;

@end
