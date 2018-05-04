//
//  CameraRollViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "CameraRollViewController.h"
#import <Photos/Photos.h>
#import "CameraRollCell.h"
#import "AlertControllerTool.h"

#define kSpecWidth adaptWidth750(20)
#define kImageWidth (kScreenWidth - 5 * kSpecWidth)/4.0

@interface CameraRollViewController ()

@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *dataArray;
/**
 记录选中Asset
 */
@property (strong, nonatomic) NSMutableArray *selectAsset;
/**
 选中的image
 */
@property (strong, nonatomic) NSMutableArray *selectArray;

@property (assign, nonatomic) BOOL isOnlyOnce;

@end

@implementation CameraRollViewController

static NSString * const reuseIdentifier = @"Cell";

-(id)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kSpecWidth;
    layout.sectionInset = UIEdgeInsetsMake(kSpecWidth, kSpecWidth, kSpecWidth, kSpecWidth);
    
    layout.itemSize = CGSizeMake(kImageWidth, kImageWidth);
    if (self=[super initWithCollectionViewLayout:layout]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CameraRollCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus != PHAuthorizationStatusAuthorized) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"加载中..."];
                    self.dataArray = [self getThumbnailImages];
                    [self.collectionView reloadData];
                    [MBProgressHUD hideHUD];
                });
            } else {
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
    } else {
        self.dataArray = [self getThumbnailImages];
    }

    self.selectArray = [NSMutableArray array];
    self.selectAsset = [NSMutableArray array];

}

- (void)viewDidLayoutSubviews
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //滚动到底部的最新照片(保证在整个Controller生命周期内只运行一次)
        if (!self.isOnlyOnce && self.collectionView.contentSize.height >= kScreenHeight) {
            
            self.isOnlyOnce = YES;
            CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
            [self.collectionView setContentOffset:bottomOffset animated:NO];
        }
    });

}
/**
 设置navigation
 */
- (void)setupNavigationBar
{
    self.title = @"相机胶卷";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleAction)];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, 0, 66, 31);
    sureButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 2;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _sureButton = sureButton;
    [self setSureButtonEnabled:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
}

/**
 关闭
 */
- (void)cancleAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 选择图片完成
 */
- (void)sureAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if (self.blcokResult) {
            
            [self.selectAsset enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self dealWithAssetImage:obj];
            }];
            self.blcokResult(self.selectArray);
        }
    }];
}

/**
 设置“完成”按钮状态
 
 @param enabled 是否可点击
 */
- (void)setSureButtonEnabled:(BOOL)enabled
{
    self.sureButton.titleLabel.alpha = enabled ? 1 : 0.5;
    self.sureButton.backgroundColor = [[UIColor colorWithString:COLOR39AF34] colorWithAlphaComponent:enabled ? 1 : 0.5];
    self.sureButton.userInteractionEnabled = enabled;
    
    if (self.selectAsset.count != 0) {
        [self.sureButton setTitle:[NSString stringWithFormat:@"完成(%lu)", (unsigned long)self.selectAsset.count] forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak CameraRollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell configDataModel:self.dataArray[indexPath.row] indexPath:indexPath selectArray:self.selectAsset];
    
    cell.blcokButton = ^(UIButton *sender) {
        
        [self dealWithImageButton:sender cell:cell indexPath:indexPath];
    };
    
    return cell;
}

/**
 处理图片选择

 @param sender button
 @param cell cell
 */
- (void)dealWithImageButton:(UIButton *)sender cell:(CameraRollCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (!sender.selected && self.selectAsset.count >= 9 - self.currentNumber) {
        
        [AlertControllerTool alertControllerWithViewController:self title:@"" message:[NSString stringWithFormat:@"你最多只能选择%ld张照片",9 - self.currentNumber] cancleTitle:@"我知道了" sureTitle:@"" cancleAction:^{
            
        } sureAction:nil];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectAsset addObject:self.dataArray[indexPath.row]];
    } else {
        [self.selectAsset removeObject:self.dataArray[indexPath.row]];
    }
    
    [self setSureButtonEnabled:self.selectAsset.count == 0 ? NO : YES];

}

/**
 asset -> image 转换方法(所有的asset对象转换为image对象)

 @param asset asset
 */
- (void)dealWithAssetImage:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    PHAsset *phAsset = asset;
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = kImageWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    // 从asset中获得图片(传原图)
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        WNLog(@"%@", result);
        
        [self.selectArray addObject:result];
        
    }];
}

/**
 获取相机胶卷图片

 @return 返回图片数组
 */
- (PHFetchResult<PHAsset *> *)getThumbnailImages
{
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:nil];
    return assets;
}


@end
