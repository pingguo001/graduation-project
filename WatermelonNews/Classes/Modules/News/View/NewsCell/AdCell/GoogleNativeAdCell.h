//
//  GoogleNativeAdCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/19.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoogleAdDelete)(NSIndexPath *indexPath);

@interface GoogleNativeAdCell : UITableViewCell

@property (copy, nonatomic) GoogleAdDelete deleteBlock;

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath;

@end
