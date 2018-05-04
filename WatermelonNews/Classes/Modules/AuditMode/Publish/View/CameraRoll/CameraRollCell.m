//
//  CameraRollCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "CameraRollCell.h"
#import <Photos/Photos.h>

@interface CameraRollCell ()

@property (strong, nonatomic) UIButton *selectButton;

@end

@implementation CameraRollCell

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
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"select_photos"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"select_photos_click"] forState:UIControlStateSelected];
    selectButton.selected = NO;
    [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    _selectButton = selectButton;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.equalTo(self);
        
    }];
    
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView).offset(adaptHeight1334(4));
        make.right.equalTo(imageView).offset(-adaptWidth750(4));
        
    }];
}

- (void)selectAction:(UIButton *)sender
{
    if (self.blcokButton) {
        self.blcokButton(sender);
    }
}

- (void)tapAction:(UIGestureRecognizer *)tap
{
    [self selectAction:self.selectButton];
}

/**
 更新数据

 @param model 数据模型
 @param indexPath 位置
 */
- (void)configDataModel:(id)model indexPath:(NSIndexPath *)indexPath selectArray:(NSMutableArray *)selectArray
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    PHAsset *phAsset = model;
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = self.size.width * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    //防止按钮状态混乱
    if ([selectArray containsObject:phAsset]) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        WNLog(@"%@", result);
        
        self.imageView.image = result;
    }];
    
}

@end
