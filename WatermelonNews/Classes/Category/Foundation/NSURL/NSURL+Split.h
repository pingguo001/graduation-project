//
//  NSURL+Split.h
//  Kratos
//
//  Created by Zhangziqi on 9/1/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Split)

- (NSDictionary *_Nullable)queryDictionary;

- (NSArray *_Nullable)queryItems;

- (NSString *_Nullable)queryItemForKey:(NSString *_Nonnull)key;

@end
