//
//  ShareAlertView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol ShareAlertViewDelegate <NSObject>

- (void)didSelectShareIndex:(NSInteger)index;

@end

@interface ShareAlertView : BaseView

- (void)showShareViewDelegate:(id<ShareAlertViewDelegate>)delegate;


@end
