//
//  TalkingDataApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/4.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkingDataApi : NSObject

/**
 *  初始化方法
 */
+ (void)initSession;

/**
 *  统计自定义事件
 *
 *  @param event 事件名称
 */
+ (void)trackEvent:(NSString *)event;

/**
 * 统计带标签的自定义事件
 *
 *	@param 	event 	事件名称
 *	@param 	label 	事件标签
 */
+ (void)trackEvent:(NSString *)event label:(NSString *)label;

/**
 *	统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *
 *	@param 	event 	事件名称
 *	@param 	label 	事件标签
 *	@param 	param	事件参数，key只支持NSString，value支持NSString和NSNumber
 */
+ (void)trackEvent:(NSString *)event
             label:(NSString *)label
             param:(NSDictionary *)param;

/**
 *	开始跟踪某一页面（可选），记录页面打开时间
 *
 *	@param 	pageName 	页面名称
 */
+ (void)trackPageBegin:(NSString *)pageName;

/**
 *	结束某一页面的跟踪（可选），记录页面的关闭时间，此方法与trackPageBegin方法结对使用
 *
 *	@param 	pageName 	页面名称，请跟trackPageBegin方法的页面名称保持一致
 */
+ (void)trackPageEnd:(NSString *)pageName;
@end