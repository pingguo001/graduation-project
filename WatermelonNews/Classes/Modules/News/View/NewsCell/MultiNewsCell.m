//
//  MultiNewsCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "MultiNewsCell.h"
#import "ImageCollectionCell.h"

#define kImageWidth (kScreenWidth - 2 * adaptWidth750(36))/3.0
#define kImageHeight adaptHeight1334(140)

@interface MultiNewsCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MultiNewsCell

- (void)p_setupViews
{
    [super p_setupViews];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = adaptWidth750(10);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.itemSize = CGSizeMake(kImageWidth, kImageHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.userInteractionEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(adaptWidth750(25));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(26) * 2);
        
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(25));
        make.height.mas_equalTo(kImageHeight);
        
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.collectionView.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(34));
        make.right.equalTo(self.titleLabel);
        
    }];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count > 3 ? 3 : self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"xinwenbg"]];

    return cell;
}

- (void)configModelData:(NewsArticleModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    self.dataArray = model.cover;
    [self.collectionView reloadData];
    [self setContentDidRed:model.isRead];
    [self setContentDidRed:[[ArticleDatabase sharedManager] queryAritcleIsRead:model.articleId]];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
