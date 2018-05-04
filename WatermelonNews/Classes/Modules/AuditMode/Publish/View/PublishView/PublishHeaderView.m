//
//  PublishHeaderView.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "PublishHeaderView.h"
#import "ImageCollectionCell.h"

@interface PublishHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, YYTextViewDelegate, ShareContentViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (assign, nonatomic) BOOL isText;

@end

@implementation PublishHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    
    self.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray array];
    
    YYTextView *textView = [[YYTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    textView.showsVerticalScrollIndicator = NO;
    textView.placeholderText = @"你想说点什么..";
    textView.delegate = self;
    [self addSubview:textView];
    _textView = textView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = adaptWidth750(30);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, adaptWidth750(10));
    
    layout.itemSize = CGSizeMake(kImageWidth, kImageWidth);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    
    self.shareContentView = [ShareContentView new];
    self.shareContentView.delegate = self;
    [self addSubview:self.shareContentView];
    
    [self.shareContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.height.mas_equalTo(adaptHeight1334(150));
        make.bottom.equalTo(self.mas_bottom).offset(-adaptHeight1334(20));
        
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(adaptWidth750(30)));
        make.right.equalTo(@(- adaptWidth750(30)));
        make.top.equalTo(@(adaptHeight1334(800 + 30)));
        make.height.mas_equalTo(adaptHeight1334(230));
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(textView);
        make.top.equalTo(textView.mas_bottom).offset(adaptHeight1334(30));
        make.height.mas_equalTo(kImageWidth);
        
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray.count >= 9) {
        
        return self.imageArray.count;
    }
    return self.imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == self.imageArray.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"add_photos"];
    } else {
        
        cell.imageView.image = self.imageArray[indexPath.row];
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerAction:)];
    [cell.imageView addGestureRecognizer:longPress];
    cell.imageView.userInteractionEnabled = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
    if (indexPath.row == self.imageArray.count) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectImages)]) {
            [self.delegate selectImages];
        }
    }
}

/**
 更新数据

 @param imageArray image数组
 */
- (void)reloadDataWithImageArray:(NSMutableArray *)imageArray;
{
    if (self.isText) {
        return;
    }
    self.imageArray = imageArray;
    
    if (!(imageArray.count % 4)) {
        
        //增加图片
        [self setCollectionViewLayoutWithNumber:imageArray.count / 4];

    } else {
        
        //删除
        if (imageArray.count < 8) {
            
            NSInteger index;
            if (imageArray.count < 4) {
                index = 0;
            } else {
                index = 1;
            }
            [self setCollectionViewLayoutWithNumber:index];

        } else {
            
            [self setCollectionViewLayoutWithNumber:2];
            
        }
    }
    [self.collectionView reloadData];
}

/**
 更新collectionView的layout

 @param number number
 */
- (void)setCollectionViewLayoutWithNumber:(NSInteger)number
{
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_textView);
        make.top.equalTo(_textView.mas_bottom).offset(adaptHeight1334(30));
        make.height.mas_equalTo(kImageWidth + number * (adaptHeight1334(30) + kImageWidth));
        
    }];
    if (self.changeHeight) {
        self.changeHeight(number);
    }
}

/**
 设置只是文本编辑

 @param isOnlyText 是否只是文本
 */
- (void)setOnlyText:(BOOL)isOnlyText
{
    self.isText = isOnlyText;
    self.collectionView.hidden = isOnlyText;
    self.shareContentView.hidden = !isOnlyText;
    if (isOnlyText) {
        
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(adaptWidth750(30)));
            make.right.equalTo(@(- adaptWidth750(30)));
            make.top.equalTo(@(adaptHeight1334(800 + 30)));
            make.bottom.equalTo(@(-adaptHeight1334(30)));
        }];
    }
}

/**
 开始编辑

 @param textView textView
 */
- (void)textViewDidChange:(YYTextView *)textView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
}

/**
 长按删除图片

 @param recognizer 手势
 */
- (void)gestureRecognizerAction:(UILongPressGestureRecognizer *)recognizer
{
    if ([(UILongPressGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan){
        // do something
        WNLog(@"长按");
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteImage:)]) {
            [self.delegate deleteImage:[(UIImageView *)recognizer.view image]];
        }
        
    }
}

- (void)shareContentActionWithModel:(id)model
{
    
}

@end
