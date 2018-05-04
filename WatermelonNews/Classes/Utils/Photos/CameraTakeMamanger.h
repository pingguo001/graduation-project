//
//  CameraTakeMamanger.h
//  CameraPhotos
//
//  Created by 刘永杰 on 16/3/14.
//  Copyright © 2016年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CameraTakeMamanger : NSObject

+ (CameraTakeMamanger *)sharedInstance;

#pragma mark - 照片
/**
 *  @brief  从Sheet选择
 *
 *  @param vc    弹出的VC
 *  @param block 回调方法
 */
- (void)cameraSheetInController:(UIViewController *)vc titleMessage:(NSString *)titleMessage handler:(void (^)(UIImage *image ,NSString * imagePath))block;

/**
 *  @brief  选择照相机拍照
 *
 *  @param vc    弹出的VC
 *  @param block 回调方法
 */
- (void)imageWithCameraInController:(UIViewController *)vc handler:(void (^)(UIImage *image ,NSString * imagePath))block;

/**
 *  @brief  从相册选择照片
 *
 *  @param vc    弹出的VC
 *  @param block 回调方法
 */
- (void)imageWithPhotoInController:(UIViewController *)vc handler:(void (^)(UIImage *image ,NSString * imagePath))block;

@end
