//
//  TitleView.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "TitleView.h"
#import "NSString+TextSzie.h"

@interface TitleView ()

@property(nonatomic,strong) UIButton *lastBtn;

@property(nonatomic,strong) UIView *bottomRedLine;

@property(nonatomic,strong) NSMutableArray *btns;

@end


@implementation TitleView

#pragma mark - public
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)selectIndex:(NSInteger)Index
{
    [self changeBtnType:self.btns[Index]];
}

//刷新标题数据
-(void)reloadData
{
    [self loadTitleItem];
}

#pragma mark -private
-(void)setupUI
{
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = UIColorFromRGBA(0xc2bfd2, 1);
    [self addSubview:bottomLine];
    
    [self addSubview:self.bottomRedLine];

}

-(void)setDataSource:(id<TitleViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self loadTitleItem];
    
}

//创建标题按钮
-(void)loadTitleItem
{
    if ([self.dataSource respondsToSelector:@selector(showTitlesWithtitleView:)]) {
        //加载子控件
        NSArray *titles = [self.dataSource showTitlesWithtitleView:self];
        if (titles.count) {
            CGFloat Y = 0;
            CGFloat H = TitleViewH;
            CGFloat W = kScreenWidth/titles.count;
            CGFloat X = 0;
            for (int i = 0; i < titles.count; i++) {
                X = i*W;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(X, Y, W, H);
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.tag = i;
                [btn setTitleColor:UIColorFromRGBA(0x4c4a56, 1) forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromRGBA(0x39AF34, 1) forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
                if (i == 0) {
                    [self btnClick:btn];
                    //设置底部红线坐标
                    self.bottomRedLine.frame = CGRectMake(0, TitleViewH-0.2, [self getBottmRedLineWidthWithBtnTitle:btn.currentTitle], 1.2);
                    self.bottomRedLine.centerX = btn.centerX;
                    
                }
                [self addSubview:btn];
                [self.btns addObject:btn];
            }
            
        }
       
    }
        

}

//根据title标题计算底部红线宽度
-(CGFloat)getBottmRedLineWidthWithBtnTitle:(NSString*)btnTitle
{
    CGSize size  = [btnTitle textSzieWithFont:[UIFont systemFontOfSize:15] andMaxSzie:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    return size.width +3;
}

#pragma mark - action
-(void)btnClick:(UIButton*)btn
{
    [self changeBtnType:btn];
    
    if ([self.dataSource respondsToSelector:@selector(titleView:selectIndex:)]) {
        [self.dataSource titleView:self selectIndex:btn.tag];
    }
    
}
//修改按钮状态
-(void)changeBtnType:(UIButton*)btn
{
    if (self.lastBtn) {
        self.lastBtn.selected = NO;
        //设置红线动画效果
        [UIView animateWithDuration:0.35 animations:^{
            self.bottomRedLine.width = [self getBottmRedLineWidthWithBtnTitle:btn.currentTitle];
            self.bottomRedLine.centerX = btn.centerX;
        }];
    }
    btn.selected = YES;
    self.lastBtn = btn;
}

#pragma mark - getter
-(UIView *)bottomRedLine
{
    if (_bottomRedLine == nil) {
        _bottomRedLine = [[UIView alloc] init];
        _bottomRedLine.backgroundColor = UIColorFromRGBA(0x39AF34, 1);
    }
    return _bottomRedLine;
}

-(NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}


@end
