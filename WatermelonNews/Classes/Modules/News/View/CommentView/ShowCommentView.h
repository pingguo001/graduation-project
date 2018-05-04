//
//  ShowCommentView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"
#import "HPGrowingTextView.h"


@interface ShowCommentView : BaseView<HPGrowingTextViewDelegate>

@property (strong, nonatomic) HPGrowingTextView *commentTextView;

- (void)showCommentView;
- (void)dimiss;


@end
