//
//  CameraRollCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockButton)(UIButton *sender);

@interface CameraRollCell : UICollectionViewCell

@property (copy, nonatomic) BlockButton blcokButton;
@property (strong, nonatomic) UIImageView *imageView;

- (void)configDataModel:(id)model indexPath:(NSIndexPath *)indexPath selectArray:(NSMutableArray *)selectArray;

@end
