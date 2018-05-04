//
//  HTTPSyncDataResponse.h
//  Kratos
//
//  Created by Zhangziqi on 16/7/7.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "HTTPDataResponse.h"

@interface HTTPSyncDataResponse : HTTPDataResponse

@property (nonatomic, strong, nullable) NSDictionary *headers;

@end
