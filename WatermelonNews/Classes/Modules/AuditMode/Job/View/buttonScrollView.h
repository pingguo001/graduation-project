//
//  buttonScrollView.h
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height

typedef void(^passButton)(NSInteger);

@interface buttonScrollView : UIScrollView

@property(nonatomic,strong) NSMutableArray *titleArray;

@property(nonatomic,strong) UIButton  *saveButton;

@property(nonatomic,copy) passButton passButton;

- (void)buttonClick:(NSInteger)buttonNumber;

- (void)setUpView;

@end
