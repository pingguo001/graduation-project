//
//  ShareContentView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/7.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol ShareContentViewDelegate <NSObject>

- (void)shareContentActionWithModel:(id)model;

@end

@interface ShareContentView : BaseView

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) id<ShareContentViewDelegate> delegate;

- (void)configDataModel:(id)model;

@end
