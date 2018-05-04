
//
//  NetworkErrorDefine.h
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#ifndef NetworkErrorDefine_h
#define NetworkErrorDefine_h

#define NETWORK_ERROR_DOMAIN @"DOMAIN_ERROR_NETWORK" /**< 错误域 */

#define ERROR_CODE_NONE 0 /**< 请求正常，无错误 */
#define ERROR_CODE_MISS_PARAMS 1 /**< 请求异常，缺少必要参数 */
#define ERROR_CODE_WRONG_FORMAT 2 /**< 请求异常，请求格式错误 */
#define ERROR_CODE_WRONG_FINGERPRINT 3 /**< 请求异常，指纹校验错误 */
#define ERROR_CODE_WECHAT_AUTH_FAILED 4 /**< 请求异常，微信校验失败 */
#define ERROR_CODE_INVALID_TOKEN 6 /**< 请求异常，token失效，需要重新获取 */
#define ERROR_CODE_INVALID_TOKENICC 5 /**< 请求异常，未知错误 */
#define ERROR_CODE_MISS_TOKEN 9001 /**< 本地异常，缺少token，只会出现在本地 */
#define ERROR_CODE_MISS_IDENTITY 9002 /**< 本地异常，缺少identity，只会出现在本地 */

#endif /* NetworkErrorDefine_h */
