//
//  AppMacro.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

// 自定义NSLog,在debug模式下打印，在release模式下取消一切NSLog
#ifdef DEBUG
#define WNLog(FORMAT, ...) fprintf(stderr,"<%s:%d>:\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define WNLog(FORMAT, ...) nil
#endif

//对象弱引用
#define kWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define kStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define PATH_DOCUMENT_DIR [NSSearchPathForDirectoriesInDomains(\
NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/*16进制颜色*/
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]



#endif /* AppMacro_h */
