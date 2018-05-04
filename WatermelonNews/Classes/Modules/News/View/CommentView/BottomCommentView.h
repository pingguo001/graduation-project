//
//  BottomCommentView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol BottomCommentViewDelegate  <NSObject>

- (void)didClickCommentViewIndex:(NSInteger)index;

@end

@interface BottomCommentView : BaseView

@property (weak, nonatomic) id<BottomCommentViewDelegate>delegate;

- (void)setCommentNumber:(NSString *)number;

@end
