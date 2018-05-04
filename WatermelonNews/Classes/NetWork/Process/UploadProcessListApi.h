//
//  UploadProcessApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/4/29.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@interface UploadProcessListApi : BaseApi

@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */
@property(nonatomic, strong) NSDictionary *_Nullable params; /**< 外部传入的请求参数 */

/**
 *  调用请求
 */
- (void)call;

@end
