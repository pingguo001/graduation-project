//
//  WNLoadingView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "WNLoadingView.h"
#import "UserManager.h"

static NSArray *s_refreshingImages = nil;

@implementation WNLoadingView

- (NSArray *)refreshingImages
{
    if (!s_refreshingImages) {
        NSMutableArray *refreshingImages  = [NSMutableArray array];
        for (int i = 1; i < 10; ++i) {
            if ([ UserManager currentUser].applicationMode.integerValue == 1) {
                //审核
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingmode%d",i]];
                [refreshingImages addObject:image];
                
            } else {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
                [refreshingImages addObject:image];
            }

        }
        s_refreshingImages = [refreshingImages copy];
    }
    return s_refreshingImages;
}

- (void)addAnimalImages:(NSInteger)offset
{
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-offset);

    }];
    self.imageView.animationDuration = 1.0;
    self.imageView.animationImages = [self refreshingImages];
}

+ (void)showLoadingInView:(UIView *)view
{
    WNLoadingView *loadingView = [WNLoadingView new];
    
    loadingView.frame = view.bounds;
    if (view.y == 0) {
        loadingView.y = 64;
    }
    
    loadingView.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
    [loadingView addAnimalImages:loadingView.y];

    [loadingView showInView:view];
}

+ (void)hideLoadingForView:(UIView *)view
{
    WNLoadingView *loadingView = [self loadingForView:view];
    if (loadingView) {
        [loadingView hide];
    }
}

+ (WNLoadingView *)loadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            return (WNLoadingView *)subview;
        }
    }
    return nil;
}

+ (void)hideAllLoadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            [(WNLoadingView *)subview hideNoAnimation];
        }
    }
}

- (void)showInView:(UIView *)view
{
    if (!view) {
        return ;
    }
    if (self.superview != view) {
        
        [self removeFromSuperview];
        
        [view addSubview:self];
        
        [view bringSubviewToFront:self];
        
    }
    
    [self.imageView startAnimating];
}

- (void)hide
{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self hideNoAnimation];
    }];
}

- (void)hideNoAnimation
{
    [self.imageView stopAnimating];
    [self removeFromSuperview];
}

- (void)dealloc
{
    [self.imageView stopAnimating];
    self.imageView.animationImages = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
