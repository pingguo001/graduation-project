//
//  selectionCellView.h
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/30.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotModel;

@interface selectionCellView : UITableViewCell

@property(nonatomic,strong) HotModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
