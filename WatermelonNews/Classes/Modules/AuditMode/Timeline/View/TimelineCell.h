//
//  TimelineCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UserView.h"
#import "CommentFooterView.h"

@protocol TimelineCellDelegate <NSObject>

- (void)personalClickAction:(NSIndexPath *)indexPath;

@optional
- (void)reportAction;

@end

static NSString *const TimelineCellID = @"TimelineCellID";

@interface TimelineCell : BaseTableViewCell

@property (weak, nonatomic) id<TimelineCellDelegate> delegate;
@property (strong, nonatomic) UserView *userInfoView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) CommentFooterView *commentView;
@property (strong, nonatomic) UILabel *readLabel;
@property (strong, nonatomic) UIView *headView;

@end
