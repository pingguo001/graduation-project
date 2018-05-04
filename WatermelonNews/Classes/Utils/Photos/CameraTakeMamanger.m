//
//  CameraTakeMamanger.m
//  CameraPhotos
//
//  Created by 刘永杰 on 16/3/14.
//  Copyright © 2016年 刘永杰. All rights reserved.
//

#import "CameraTakeMamanger.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@interface CameraTakeMamanger()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) UIViewController *vc;
@property(nonatomic, strong) UIImagePickerController *imagePickerController;
@property(nonatomic, strong) void (^resultBlock)(UIImage *image ,NSString * imagePath);
@property(nonatomic, strong) void (^resultVideoBlock)(NSURL *videoUrl);
@end

@implementation CameraTakeMamanger

- (BOOL)willDealloc
{
    return NO;
}

static CameraTakeMamanger *sharedInstance = nil;
#pragma mark Singleton Model
+ (CameraTakeMamanger *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CameraTakeMamanger alloc]init];
        sharedInstance.imagePickerController = [[UIImagePickerController alloc]init];
        sharedInstance.imagePickerController.delegate = sharedInstance;
        sharedInstance.imagePickerController.allowsEditing = YES;
    });
    return sharedInstance;
}

//弹出alert选择
- (void)cameraSheetInController:(UIViewController *)vc titleMessage:(NSString *)titleMessage handler:(void (^)(UIImage *image ,NSString * imagePath))block {
    @kWeakObj(self)
//    @kWeakObj(vc);
    self.vc = vc;
    self.resultBlock = block;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        selfWeak.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
         AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n应用相机权限受限，请在iPhone的“设置-隐私-相机”选项中，允许西瓜头条访问您的相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        selfWeak.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [vc presentViewController:selfWeak.imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *cameraAction= [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        selfWeak.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [vc presentViewController:selfWeak.imagePickerController animated:YES completion:^{}];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:photosAction];
    [alert addAction:cameraAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
    
}

//直接弹出相机
- (void)imageWithCameraInController:(UIViewController *)vc handler:(void (^)(UIImage *image ,NSString * imagePath))block {
    self.vc = vc;
    self.resultBlock = block;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self.vc presentViewController:self.imagePickerController animated:YES completion:^{}];
}

//直接弹出相册
- (void)imageWithPhotoInController:(UIViewController *)vc handler:(void (^)(UIImage *image ,NSString * imagePath))block {
    self.vc = vc;
    self.resultBlock = block;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.vc presentViewController:self.imagePickerController animated:YES completion:^{}];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (![mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 摄像
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        self.resultVideoBlock(videoUrl);
        
    } else {
        // 照片
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSUUID UUID].UUIDString];
        
        [self saveImage:image withName:imageName];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        self.resultBlock(savedImage,fullPath);
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *temp = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [temp writeToFile:fullPath atomically:YES];
}

@end
