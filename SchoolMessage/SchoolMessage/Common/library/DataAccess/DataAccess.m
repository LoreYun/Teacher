//
//  DataAccess.m
//  ASI数据请求
//
//  Created by Ysj on 14-4-21.
//  Copyright (c) 2014年 Ysj. All rights reserved.
//

#import "DataAccess.h"



@implementation DataAccess

+ (ASIHTTPRequest *)requestWithParams:(NSMutableDictionary *)params
                           HttpMethod:(NSString *)httpMethod
                        CompleteBlock:(RequestFinishBlock )block
{
    
    //get 请求
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"Get"];
    if (compareRet == NSOrderedSame)
    {
        NSString *urlSting = [NSString string];
        NSMutableString *paramString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; allKeys.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            [paramString appendFormat:@"%@=%@",key,value];
            
            if (i< params.count - 1)
            {
                [paramString appendFormat:@"&"];
            }
        }
        
        if (paramString.length > 0 )
        {
           urlSting =  [rootUrl stringByAppendingFormat:@"&%@",paramString];
        }
    }
    
    
    
    //post请求
    NSURL *url = [NSURL URLWithString:rootUrl];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //超时时间
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:httpMethod];
    
    
    
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compareRet1 == NSOrderedSame)
    {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < params.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            //文件 or not
            
            if ([value isKindOfClass:[NSData class]])
            {
                [request addData:value forKey:key];
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (block != nil)
        {
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return nil;
}


+ (ASIHTTPRequest *)nsstringWithParams:(NSMutableDictionary *)params
                            HttpMethod:(NSString *)httpMethod
                         CompleteBlock:(RequestFinishBlock )block
{
    //get 请求
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"Get"];
    if (compareRet == NSOrderedSame)
    {
        NSString *urlSting = [NSString string];
        NSMutableString *paramString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; allKeys.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            [paramString appendFormat:@"%@=%@",key,value];
            
            if (i< params.count - 1)
            {
                [paramString appendFormat:@"&"];
            }
        }
        
        if (paramString.length > 0 )
        {
            urlSting =  [rootUrl stringByAppendingFormat:@"&%@",paramString];
        }
    }
    
    
    
    //post请求
    NSURL *url = [NSURL URLWithString:rootUrl];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //超时时间
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:httpMethod];
    
    
    
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compareRet1 == NSOrderedSame)
    {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < params.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            //文件 or not
            
            if ([value isKindOfClass:[NSData class]])
            {
                [request addData:value forKey:key];
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        //NSError *error = nil;
        id result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (block != nil)
        {
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return nil;

}


+(ASIHTTPRequest *)loginAccess:(NSMutableDictionary *)params
                    HttpMethod:(NSString *)httpMethod
                 CompleteBlock:(RequestFinishBlock )block
{
    NSString *urlSting = [NSString string];
    //get 请求
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"Get"];
    if (compareRet == NSOrderedSame)
    {
        
        NSMutableString *paramString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < allKeys.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            [paramString appendFormat:@"%@=%@",key,value];
            if (i< params.count - 1)
            {
                [paramString appendFormat:@"&"];
            }
            //NSLog(@"%@",paramString);
            
        }
        
        if (paramString.length > 0 )
        {
            urlSting = [rootUrl stringByAppendingFormat:@"%@",paramString];
            //urlSting =  [@"%@/UserService/LoginService/IOSLoginservice.aspx?" stringByAppendingFormat:@"%@",paramString];
            // NSLog(@"%@",urlSting);
        }
    }
    
    
    
    //post请求
    NSURL *url = [NSURL URLWithString:urlSting];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //超时时间
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:httpMethod];
    
    
    
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compareRet1 == NSOrderedSame)
    {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < params.count; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params valueForKey:key];
            
            //文件 or not
            
            if ([value isKindOfClass:[NSData class]])
            {
                [request addData:value forKey:key];
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    __weak ASIFormDataRequest *_request = request;
    [_request setCompletionBlock:^{
        NSData *data = _request.responseData;
        
        NSError *error;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //NSLog(@"%@",result);
        request = _request;
        if (block != nil)
        {
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return nil;
}



@end
