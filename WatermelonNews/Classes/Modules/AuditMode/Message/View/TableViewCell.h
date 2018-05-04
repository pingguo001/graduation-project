//
//  TableViewCell.h
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *message;
@property (weak, nonatomic) IBOutlet UILabel *messagelabel;
@property (weak, nonatomic) IBOutlet UILabel *describeMessage;

@end
