//
//  NativeExpressAdApi.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/18.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NativeExpressAdApi.h"
#import "GDTNativeExpressAdView+Extention.h"

#define APPKEY      @"1106417984"
#define PLACEMENTID_1 @"2050020610086077"     //大图
#define PLACEMENTID_2 @"9080622600087009"     //左图右文

#define ad1Number 10
#define ad2Number 5


@interface NativeExpressAdApi ()<GDTNativeExpressAdDelegete>

@property (weak, nonatomic) id<NativeExpressAdApiDelegate>delegate;
@property (strong, nonatomic) GDTNativeExpressAd *nativeExpressAd1;
@property (strong, nonatomic) GDTNativeExpressAd *nativeExpressAd2;

@property (strong, nonatomic) NSMutableArray *ad1Array;
@property (strong, nonatomic) NSMutableArray *ad2Array;

@property (assign, nonatomic) NSInteger fetchTime;


@end

@implementation NativeExpressAdApi

/**
 初始化原生模板广告
 
 @param delegate 代理
 @return 广告对象
 */
- (id)initTencentAdWithDelegate:(id<NativeExpressAdApiDelegate>)delegate
{
    if (self = [super init]) {
        

        
        self.nativeExpressAd2 = [[GDTNativeExpressAd alloc] initWithAppkey:APPKEY placementId:PLACEMENTID_2 adSize:CGSizeMake(kScreenWidth, 120)];
        self.nativeExpressAd2.delegate = self;
        
        _delegate = delegate;

    }
    return self;
}

/**
 拉取原生模板广告数据
 */
- (void)fetchNativeExpressAd
{
    self.nativeExpressAd1 = [[GDTNativeExpressAd alloc] initWithAppkey:APPKEY placementId:PLACEMENTID_1 adSize:CGSizeMake(kScreenWidth, 340)];
    self.nativeExpressAd1.delegate = self;
    
    // 拉取广告
    [self.nativeExpressAd1 loadAd:ad1Number];
//    [self.nativeExpressAd2 loadAd:ad2Number];
    
    _fetchTime++;
    
    self.ad1Array = [NSMutableArray array];
//    self.ad2Array = [NSMutableArray array];

}

#pragma mark - GDTNativeExpressAdDelegate

/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{

//    if (views.count / ad1Number == _fetchTime) {
    
//        NSArray *viewsArray = [views subarrayWithRange:NSMakeRange(views.count - ad1Number, ad1Number)];
        self.ad1Array = [self transformModelWithDicArray:views].mutableCopy;

//    } else if (views.count / ad2Number == _fetchTime) {
//        
//        NSArray *viewsArray = [views subarrayWithRange:NSMakeRange(views.count - ad2Number, ad2Number)];
//        self.ad2Array = [self transformModelWithDicArray:viewsArray].mutableCopy;
//        
//    }
    if (self.ad1Array.count && self.delegate != nil && [self.delegate respondsToSelector:@selector(nativeExpressAdDidFetchSuccess:)]) {
        
//        for (int i = 0; i < self.ad2Array.count; i++) {
//            
//            [self.ad1Array insertObject:self.ad2Array[i] atIndex:2 * i + 1 + i];
//        }
        [self.delegate nativeExpressAdDidFetchSuccess:self.ad1Array];
    } else {
        
        [self.delegate nativeExpressAdDidFetchFailure:nil];

    }
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(nativeExpressAdDidFetchFailure:)]) {
        [self.delegate nativeExpressAdDidFetchFailure:error];
    }
}
/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    WNLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    WNLog(@"%s",__FUNCTION__);
    for (UIView *view in nativeExpressAdView.subviews.firstObject.subviews.firstObject.subviews) {
        //腾讯广告标题
        NSLog(@"%@",[((UILabel *)view).text componentsSeparatedByString:@"\n"].firstObject);
    }
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    WNLog(@"%s",__FUNCTION__);
    [TalkingDataApi trackEvent:TD_CLICK_TENCENTAD];
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    [TalkingDataApi trackEvent:TD_CLOSE_TENCENTAD];
    if (nativeExpressAdView.deleteBlock) {
        nativeExpressAdView.deleteBlock();
    }
}

- (NSArray *)transformModelWithDicArray:(NSArray *)dataArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (GDTNativeExpressAdView *view in dataArray) {
        
        TencentAdModel *model = [TencentAdModel new];
        model.source = expressAdType;
        model.expressAdView = view;
//        if (dataArray.count == ad1Number) {
            model.expressAdType = adType1;
//        } else {
//            model.expressAdType = adType2;
//        }
        [modelArray addObject:model];
    }
    return modelArray;
}


@end
