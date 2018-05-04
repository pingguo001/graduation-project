//
//  CameraRollViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockResult)(NSMutableArray *array);

@interface CameraRollViewController : UICollectionViewController

/**
 目前已经选择的图片数量
 */
@property (assign, nonatomic) NSInteger currentNumber;

/**
 回调图片数组
 */
@property (copy, nonatomic) BlockResult blcokResult;

@end
