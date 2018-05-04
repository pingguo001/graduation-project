//
//  ShareImageTool.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/13.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShareImageTool.h"

@implementation ShareImageTool

+ (UIImage *)createShareImageWithUrl:(NSString *)urlStr
{
    UIImage *sourceImage = [UIImage imageNamed:@"share_qr_code_bg"];
    UIImage *codeImage = [self creatCIQRCodeImageWithUrlImage:urlStr];
    UIImage *headImage = [UIImage imageNamed:@"share_headImage"];

    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    
    //二维码位置
    CGContextSetLineWidth(context, 15.0);//线的宽度
    UIColor *aColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    
    CGRect codeRect = CGRectMake(imageSize.width/2 - codeImage.size.width / 2,imageSize.height - codeImage.size.height - 140, codeImage.size.width, codeImage.size.height);
    CGContextStrokeRect(context, codeRect);
    //绘制
    [codeImage drawInRect:codeRect];
    
    //用户头像位置
    CGContextSetLineWidth(context, 1.0);//线的宽度
    UIColor *twoColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, twoColor.CGColor);//线框颜色
    
    CGRect headRect1 = CGRectMake(imageSize.width - 100, imageSize.height - 620, 80, 80);
    CGContextStrokeRect(context, headRect1);
    CGContextClip(context);

    CGRect headRect2 = CGRectMake(imageSize.width - 100, imageSize.height - 965, 80, 80);
    CGContextStrokeRect(context, headRect2);
    CGContextClip(context);
    
    [headImage drawInRect:headRect1];
    [headImage drawInRect:headRect2];
    
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)createSuccessShareImageWithUrl:(NSString *)urlStr isFiftyMoney:(BOOL)isFiftyMoney;
{
    
    UIImage *sourceImage = [UIImage imageNamed:isFiftyMoney ? @"exchange_success" : @"exchange_success_100"];
    UIImage *codeImage = [self creatCIQRCodeImageWithUrlImage:urlStr];
    
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    
    //二维码位置
    CGContextSetLineWidth(context, 15.0);//线的宽度
    UIColor *aColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    
    CGRect codeRect = CGRectMake(imageSize.width/2 - codeImage.size.width / 4 +5,imageSize.height - codeImage.size.height/2 - 95, codeImage.size.width/2, codeImage.size.height/2);
    CGContextStrokeRect(context, codeRect);
    //绘制
    [codeImage drawInRect:codeRect];
    
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  生成二维码
 */
+ (UIImage *)creatCIQRCodeImageWithUrlImage:(NSString *)urlImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3. 给过滤器添加数据
    NSString *dataString = urlImage;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    // 5. 返回二维码
    return [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:414/1.5];
}

@end
