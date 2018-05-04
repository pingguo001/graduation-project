//
//  PublishHeaderView.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "YYTextView.h"
#import "ShareContentView.h"

#define kImageWidth (kScreenWidth - 5 * adaptWidth750(30))/4.0

typedef void(^ChangeHeight)(NSInteger index);

@protocol PublishHeaderViewDelegate  <NSObject>

- (void)selectImages;
- (void)deleteImage:(UIImage *)image;
- (void)textViewDidChange:(YYTextView *)textView;


@end

@interface PublishHeaderView : UIView

@property (copy, nonatomic) ChangeHeight changeHeight;
@property (strong, nonatomic) id<PublishHeaderViewDelegate>delegate;
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) ShareContentView *shareContentView;

- (void)reloadDataWithImageArray:(NSMutableArray *)imageArray;
- (void)setOnlyText:(BOOL)isOnlyText;

@end
