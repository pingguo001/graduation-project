//
//  CommentCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TimelineCell.h"

static NSString *const CommentCellID = @"CommentCellID";

@interface CommentCell : BaseTableViewCell

@property (weak, nonatomic) id<TimelineCellDelegate>delegate;

@end
