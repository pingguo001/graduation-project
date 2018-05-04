//
//  MultiNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_setupViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)p_setupViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"xinwenbg"];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.equalTo(self);
        
    }];
    
}

@end
