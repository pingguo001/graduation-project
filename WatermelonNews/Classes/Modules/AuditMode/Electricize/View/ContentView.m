//
//  ContentView.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "ContentView.h"

@interface ContentView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) NSArray *childViewControllers;

@property(nonatomic,weak) UIViewController *parentVC;

@property(nonatomic,strong) UICollectionView*collectionView;

@property(nonatomic,assign) NSInteger currentPage;

@end

@implementation ContentView

#pragma mark - public
-(instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray*)childViewControllers  parentVC:(UIViewController*)parentVC
{
    if (self = [super initWithFrame:frame]) {
        self.childViewControllers = childViewControllers;
        self.parentVC = parentVC;
        [self addSubview:self.collectionView];
    }
    return self;
}

-(void)scrollToIndex:(NSInteger)index
{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIViewController *child = self.childViewControllers[indexPath.item];
    child.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:child.view];
    [self.parentVC addChildViewController:child];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = scrollView.contentOffset.x/scrollView.width;
}

#pragma mark - getter
-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.width, self.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource =self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}


@end
