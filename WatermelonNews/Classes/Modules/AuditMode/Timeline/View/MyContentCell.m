//
//  MyContentCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "MyContentCell.h"
#import "ImageCollectionCell.h"
#import "TimelineModel.h"
#import "XLPhotoBrowser.h"

#define kImageWidth1 (kScreenWidth - 2 * adaptWidth750(40))/3.0
#define kImageWidth2 (kScreenWidth - 2 * adaptWidth750(30) - adaptWidth750(10))/2.0

@interface MyContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (assign, nonatomic) NSInteger imageWith;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation MyContentCell

- (void)p_setupViews
{
    [super p_setupViews];
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(30));
        make.height.mas_equalTo(200);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    
    [self.readLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.collectionView.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    
}

- (void)configModelData:(TimelineModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    if (model.cover.length != 0) {
        self.dataArray = [model.cover componentsSeparatedByString:@","].mutableCopy;
    } else {
        self.dataArray = [NSMutableArray array];
    }
    NSInteger countHeight;
    if (self.dataArray.count == 2) {
        
        self.imageWith = kImageWidth2;
        countHeight = 1;
        
    } else if (self.dataArray.count == 4){
        
        self.imageWith = kImageWidth2;
        countHeight = 2;

    } else if (self.dataArray.count <= 6) {
        
        if (self.dataArray.count <= 3) {
            self.imageWith = kImageWidth1;
            countHeight = 1;
        } else {
            self.imageWith = kImageWidth1;
            countHeight = 2;
        }
    } else {
        
        self.imageWith = kImageWidth1;
        countHeight = 3;
    }
    
    if (self.dataArray.count == 0) {
        self.collectionView.hidden = YES;
        self.imageWith = 0;
        
    } else {
        
        self.collectionView.hidden = NO;
    }
    
    self.layout.itemSize = CGSizeMake(self.imageWith, self.imageWith);
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(30));
        make.height.mas_equalTo(self.imageWith * countHeight + adaptWidth750(10) * (countHeight - 1));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(20));
        
    }];
    [self.collectionView reloadData];
    if (model.is_myself) {
        self.imageArray = [NSMutableArray array];
        for (NSString *urlStr in self.dataArray) {
            UIImage *image = [UIImage imageWithContentsOfFile:urlStr];
            if (image) {
                [self.imageArray addObject:image];
            }
        }
    }
}

#pragma mark - CollectionViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *urlStr = self.dataArray[indexPath.row];
    
    if (urlStr == nil || urlStr.length == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"xinwenbg"];
        
    } else {
        
        if ([urlStr containsString:@"http:"] ||[urlStr containsString:@"https:"] ) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xinwenbg"]];

        } else {
            
            cell.imageView.image = [UIImage imageWithContentsOfFile:urlStr];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlStr = self.dataArray[indexPath.row];

    if ([urlStr containsString:@"http:"] ||[urlStr containsString:@"https:"] ) {
        [XLPhotoBrowser showPhotoBrowserWithImages:self.dataArray currentImageIndex:indexPath.row];

    } else {
        [XLPhotoBrowser showPhotoBrowserWithImages:self.imageArray currentImageIndex:indexPath.row];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumLineSpacing = adaptWidth750(10);
        self.layout.minimumInteritemSpacing = adaptWidth750(5);
        
        self.layout.itemSize = CGSizeMake(kImageWidth1, kImageWidth1);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [self.collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.userInteractionEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
