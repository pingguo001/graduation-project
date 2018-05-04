//
//  TabHeaderView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TabHeaderView.h"
#import "NewsCategoryModel.h"

#define kButtonWidth 55
#define kFontSize 17
#define kSelectFontSize 18
#define kMaxWidth kScreenWidth / 2

@interface TabHeaderView ()

@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIView *animationView;
@property (weak, nonatomic) id<TabHeaderViewDelegate> delegate;

@end

@implementation TabHeaderView

- (void)p_setupViews
{
    self.userInteractionEnabled = YES;
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.backScrollView];
    
}

- (void)cofigureDelegate:(id<TabHeaderViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray withMultiple:(CGFloat)multiple
{
    self.delegate = delegate;
    
    self.backScrollView.contentSize = CGSizeMake(dataArray.count * kButtonWidth*multiple + kButtonWidth*multiple/2.0, self.height);
    
    [dataArray enumerateObjectsUsingBlock:^(NewsCategoryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(idx * kButtonWidth*multiple + kButtonWidth*multiple / 4.0, 15, kButtonWidth*multiple, 20);
        button.tag = 200 + idx;
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:button];

        
        UIView *animationView = [UIView new];
        animationView.backgroundColor = [UIColor colorWithString:COLOR39AF34];
        animationView.layer.cornerRadius = 2;
        animationView.layer.masksToBounds = YES;
        animationView.tag = 300 + idx;
        [self.backScrollView addSubview:self.animationView];
        animationView.hidden = YES;
        [self.backScrollView addSubview:animationView];
        
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(15);
            make.centerX.equalTo(button);
            make.top.equalTo(button.mas_bottom).offset(3);
            
        }];
        
    }];
    
    UIButton *button = (UIButton *)[self viewWithTag:200];
    button.titleLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    button.selected = YES;
    
    self.saveButton = button;
    UIView *animationView = [self viewWithTag:300];
    animationView.hidden = NO;
    
}

- (void)buttonAction:(UIButton *)sender
{

    if (self.saveButton != sender) {
        
        UIView *currentView = [self viewWithTag:self.saveButton.tag + 100];
        
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        sender.selected = !sender.selected;
        self.saveButton.selected = !self.saveButton.selected;
        self.saveButton = sender;
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
        UIView *nextView = [self viewWithTag:self.saveButton.tag + 100];
        
        currentView.hidden = YES;
        nextView.hidden = NO;
            
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectTabIndex:)]) {
            
            [self.delegate didSelectTabIndex:sender.tag - 200];
        }
        
        //保证按钮一直在最中间显示
        CGFloat centerWidth = sender.x + sender.width / 2.0;
        
        if (centerWidth > kMaxWidth &&  self.backScrollView.contentSize.width - centerWidth > kMaxWidth) {
            
            [self.backScrollView setContentOffset:CGPointMake(centerWidth  - kMaxWidth, 0) animated:YES];
            
        } else if(centerWidth < kMaxWidth) {
            
            [self.backScrollView setContentOffset:CGPointZero animated:YES];

        } else if(self.backScrollView.contentSize.width - centerWidth <= kMaxWidth){
            
            [self.backScrollView setContentOffset:CGPointMake(self.backScrollView.contentSize.width - kScreenWidth, 0) animated:YES];
        }
        
    } else {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didRefreshClickIndex:)]) {
            [self.delegate didRefreshClickIndex:sender.tag - 200];
        }
    }
}

- (void)selectTabIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[self viewWithTag:index + 200];
    [self buttonAction:button];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
