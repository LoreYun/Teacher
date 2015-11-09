//
//  DataAccess.h
//  ASI数据请求
//
//  Created by Ysj on 14-4-21.
//  Copyright (c) 2014年 Ysj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
typedef void (^RequestFinishBlock)(id result);

@interface DataAccess : NSObject




+ (ASIHTTPRequest *)requestWithParams:(NSMutableDictionary *)params
                           HttpMethod:(NSString *)httpMethod
                        CompleteBlock:(RequestFinishBlock )block;


+ (ASIHTTPRequest *)nsstringWithParams:(NSMutableDictionary *)params
                           HttpMethod:(NSString *)httpMethod
                        CompleteBlock:(RequestFinishBlock )block;

+(ASIHTTPRequest *)loginAccess:(NSMutableDictionary *)params
                    HttpMethod:(NSString *)httpMethod
                 CompleteBlock:(RequestFinishBlock )block;

//+ (ASIHTTPRequest *)oldStringRequestWithParams:(NSMutableDictionary *)params
//                              HttpMethod:(NSString *)httpMethod
//                           CompleteBlock:(RequestFinishBlock )block;
@end
