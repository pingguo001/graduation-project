//
//  RedPacketView.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/20.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "BaseView.h"

typedef void(^CompleteBlock)();

@interface RedPacketOpenView : BaseView

@property (copy, nonatomic) CompleteBlock complete;

- (void)show;

- (void)dismiss;

@end
