//
//  selectCellView.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/30.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "selectCellView.h"

@implementation selectCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
