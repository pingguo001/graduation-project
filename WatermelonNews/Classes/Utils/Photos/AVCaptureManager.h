//
//  AVCaptureManager.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/28.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^Result)(id object);

@interface AVCaptureManager : NSObject

/**
 单例对象

 @return 摄像管理者
 */
+ (instancetype)sharedManager;

/**
 初始化设备session

 @param previewLayer 回调图层渲染
 */
- (void)captureSessionPreviewLayer:(Result)previewLayer;

/**
 拍照
 
 @param resultImage 回调图片
 */
- (void)shootImage:(Result)resultImage;

/**
 对焦

 @param point 触摸点
 */
- (void)focusingAtPoint:(CGPoint)point;

/**
 切换前后摄像头
 */
- (void)switchFrontAndBackCameras;

/**
 开始捕获图像
 */
- (void)startRunning;

/**
 停止捕获图像
 */
- (void)stopRunning;

/**
 是否允许访问相机
 
 @return 是/否
 */
- (BOOL)isCanUseCamera;


@end
