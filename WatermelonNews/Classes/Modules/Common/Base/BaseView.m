//
//  BaseView.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/14.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
