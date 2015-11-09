//
//  UtilManager.h
//  VXiaoYuan
//
//  Created by LI on 14-12-17.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilManager : NSObject


/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL)isValidateEmail:(NSString *)email;

/******字符串转base64（包括DES加密）******/
#define __BASE64( text )        [UtilManager base64StringFromText:text]

/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [UtilManager textFromBase64String:base64]

/****** MD5 加密******/
#define __MD5( text )        [UtilManager md5:text]

/************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : md5
 **********************************************************/
+ (NSString *)md5:(NSString *)str;

+(NSString *)speMd5:(NSString *)content;

+ (UIColor *)getColorWithHexString:(NSString *)stringToConvert;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage *)imageNamed:(NSString *)imageName;

@end
