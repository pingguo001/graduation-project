//
//  ShootView.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShootViewController.h"
#import "ShootView.h"
#import "AVCaptureManager.h"

@interface ShootViewController ()<ShootViewDelegate>

@property (strong, nonatomic) AVCaptureManager *sessionManager;
@property (strong, nonatomic) ShootView *shootView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ShootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.sessionManager = [AVCaptureManager sharedManager];
    if ([self.sessionManager isCanUseCamera]) {
        [self initCaptureDevice];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comera_switch"] style:UIBarButtonItemStyleDone target:self action:@selector(switchAction)];
    UIImage *img = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIImage *img = [UIImage imageWithColor:[UIColor colorWithString:COLOR323941] size:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}

/**
 初始化摄像设备
 */
- (void)initCaptureDevice
{
    //初始化摄像头设备
    [self.sessionManager captureSessionPreviewLayer:^(AVCaptureVideoPreviewLayer *previewLayer) {
        [self.view.layer addSublayer:previewLayer];
    }];
    //开始捕获
    [self.sessionManager startRunning];
    //自定义图层
    self.shootView = [[ShootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.shootView.delegate = self;
    [self.view addSubview: self.shootView];
}

#pragma mark - ShootViewDelegateAction

/**
 摄像头切换
 */
- (void)switchAction
{
    [self.sessionManager switchFrontAndBackCameras];
}

/**
 关闭
 */
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 对焦
 */
- (void)focusingActionAtPoint:(CGPoint)point
{
    [self.sessionManager focusingAtPoint:point];
}

/**
 拍照
 */
- (void)shootAction
{
    [self.sessionManager shootImage:^(UIImage *image) {
        [self.shootView shootComplete];
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view insertSubview:_imageView belowSubview:_shootView];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = image;
        [self.sessionManager stopRunning];
    }];
}

/**
 取消重拍
 */
- (void)cancleAction
{
    [self.imageView removeFromSuperview];
    [self.sessionManager startRunning];
}

/**
 完成拍照
 */
- (void)sureAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.blcokImage && self.imageView.image != nil) {
        self.blcokImage(self.imageView.image);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
