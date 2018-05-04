//
//  InviteHelpCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^InviteAction)();

static NSString *const InviteHelpCellID = @"InviteHelpCellID";

@interface InviteHelpCell : BaseTableViewCell

@property (copy, nonatomic) InviteAction inviteAction;

@end
