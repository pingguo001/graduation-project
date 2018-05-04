//
//  NetworkMacro.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#warning 上线检查

#ifdef DEBUG
//#define URL_BASE_NEWS @"http://139.129.162.59:8333"
#define URL_BASE_NEWS @"http://xigua.lingyongqian.cn"
#else
#define URL_BASE_NEWS @"http://xigua.lingyongqian.cn"
#endif

#ifdef DEBUG
//#define URL_BASE_ICC @"http://139.129.162.59:8308"
#define URL_BASE_ICC @"http://api.daodaozhushou.com:8308"
#else
#define URL_BASE_ICC @"http://api.daodaozhushou.com:8308"
#endif

#define APPLICATIONCHANNEL @"xiguatoutiao"

#define CLIENTCHANNEL      @"applestore"
