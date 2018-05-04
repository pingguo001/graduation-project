//
//  RedPacketView.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/20.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "RedPacketOpenView.h"

@interface RedPacketOpenView ()
@property (strong, nonatomic)  UIImageView *openImageView;
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation RedPacketOpenView

- (void)p_setupViews
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.4];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"xghb_bg"];
    [self addSubview:imageView];
    imageView.layer.cornerRadius = adaptHeight1334(10);
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.left.mas_equalTo(adaptWidth750(50));
        make.height.mas_equalTo(adaptHeight1334(870));
        
    }];
    _imageView = imageView;
    
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:clearButton];
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(imageView);
        make.height.width.mas_equalTo(adaptWidth750(80));
        
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"window_btn_close"] forState:UIControlStateNormal];
    [imageView addSubview:button];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(imageView).offset(adaptWidth750(30));
        
    }];
    
    UIImageView *openImageView = [[UIImageView alloc] init];
    openImageView.image = [UIImage imageNamed:@"qbkai"];
    openImageView.userInteractionEnabled = YES;
    _openImageView = openImageView;
    [imageView addSubview:openImageView];
    [openImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView);
        make.bottom.equalTo(imageView).offset(-adaptHeight1334(166));
        
    }];
    
    UITapGestureRecognizer *open = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAction)];
    [openImageView addGestureRecognizer:open];
    
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.imageView.layer.position = self.center;
    self.imageView.transform = CGAffineTransformMakeScale(1.20, 1.20);
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss
{
    self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.2 delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
         self.imageView.transform = CGAffineTransformMakeScale(0.000001, 0.0000001);
                         
     } completion:^(BOOL finished) {
         [super removeFromSuperview];
     }];

}

- (void)openAction
{
    self.openImageView.animationImages = self.imgArray;
    self.openImageView.animationDuration = 0.5;
    [self.openImageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
        [self.openImageView stopAnimating];
        if (self.complete) {
            
            self.complete();
        }
    });
    
}

-(NSMutableArray *)imgArray
{
    if (!_imgArray) {
        
        _imgArray = [NSMutableArray array];
        for (int i = 2; i<10; i++) {
            if (i<10) {
                UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"window_btn_open0%d",i]];
                [_imgArray addObject:img];
            }
        }
    }
    return _imgArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
