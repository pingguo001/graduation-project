//
//  BaseTableViewCell.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/14.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

- (void)p_setupViews;

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath;


@end
