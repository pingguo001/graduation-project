//
//  LoginManager.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/6.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginResponseDelegate <NSObject>
@required
- (void)loginSuccess:(NSDictionary *_Nullable)result;

- (void)loginFailure:(NSError *_Nonnull)error;
@end

@protocol LoginDelegate <NSObject>
@required
- (void)login;
@end

@interface LoginManager : NSObject <LoginDelegate>
@property (nonatomic, weak) id<LoginResponseDelegate> _Nullable delegate;

- (void)login;

@end
