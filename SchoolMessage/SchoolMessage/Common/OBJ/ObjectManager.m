//
//  ObjectManager.m
//  SchoolMessage
//
//  Created by LI on 15/1/26.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ObjectManager.h"
#import "AFHTTPRequestOperationManager.h"

#define DEVICE @"ios"

#define DEVICE_CODE @"ping"

#define DIV @"@`"

#define MIDDLE_CODE @"0"

#define END_CODE @"-1"

#define VERSION  [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""]

#define FLAG @"flag"

#define ISSUCCESS @"IsSuccess"

#define Msg @"Msg"

@interface ObjectManager ()

@property (nonatomic,copy) NSString * cloud_url;

@end

@implementation ObjectManager
{
    NSString *_root_url;
}


#pragma mark request method

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)requestDataOnPost:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSString *time = [NSString stringWithFormat:@"%qi",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
    NSString *bparam = [self Encode2B:data time:time flag:flag];
    NSString *fparam = [self Encode2F:data time:time flag:flag];
    NSDictionary *parameters = @{@"b":bparam,@"f":fparam,@"t":time};//,@"c":cparam};
//    NSLog(@"result b %@  c %@",bparam,cparam);
    [self requestDataOnPost:parameters callback:callback];
}

-(void)requestDataOnGet:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSString *time = [NSString stringWithFormat:@"%qi",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
    NSString *bparam = [self Encode2B:data time:time flag:flag];
    NSString *fparam = [self Encode2F:data time:time flag:flag];
    NSDictionary *parameters = @{@"b":bparam,@"f":fparam,@"t":time};
//        NSLog(@"result %@",parameters);
    [self requestDataOnGet:parameters callback:callback];
}

-(void)requestDataOnPost:(NSDictionary *)parameters callback:(void (^)(BOOL, NSDictionary *))cb
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:[self getRootUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        cb(YES,dic);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        cb(NO,nil);
    }];
}

-(void)requestDataOnGet:(NSDictionary *)parameters callback:(void (^)(BOOL, NSDictionary *))cb
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:[self getRootUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *success = [dic objectForKey:ISSUCCESS];
        
        cb(success.boolValue,dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        cb(NO,nil);
    }];
}

-(void)getCloudConfig:(NSString *)username callback:(void (^)(BOOL success, NSDictionary *data))callback
{
    NSDictionary *dic =@{@"1":username};
    NSString *time = [NSString stringWithFormat:@"%qi",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
    NSString *bparam = [self Encode2B:dic time:time flag:@"10"];
    NSDictionary *parameters = @{@"b":bparam,@"flag":@"parent"};
    [ObjectManager sharedInstance].cloud_url  = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:rootCloudUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *success = [dic objectForKey:ISSUCCESS];
        if(success)
        {
            [ObjectManager sharedInstance].cloud_url  = [[dic objectForKey:S_OBJ] objectForKey:@"Url"];
        }
        callback(success.boolValue,dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO,nil);
    }];
}

-(NSString *)Encode2B:(NSDictionary *)dic time:(NSString *)time flag:(NSString *)flag
{
    
    NSString *result = @"";


    NSArray *sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString* key in sortedArray) {
        result = [NSString stringWithFormat:@"%@%@%@",result,[dic objectForKey:key],DIV];
    }

    result = [NSString stringWithFormat:@"%@%@%@%@",flag,DIV,result,END_CODE];

    return result;
}

-(NSString *)Encode2F:(NSDictionary *)dic time:(NSString *)time flag:(NSString *)flag
{
    NSString * b=[self Encode2B:dic time:time flag:flag];
    long long t0 = time.longLongValue;
    long long t= t0%9999;
    NSString * f=[[UtilManager md5:[NSString stringWithFormat:@"%@%qiwhwy",b,t]] uppercaseString];
    return f;
}

-(void)uploadImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback
{
    //    NSURL *url = [NSURL URLWithString:uploadImageUrl];
    [self uploadImage2Server:data url:[[AccountManager sharedInstance].LoginInfos getPersonUploadUrl] callback:callback];
    
}

-(void)uploadGroupImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback
{
    [self uploadImage2Server:data url:[[AccountManager sharedInstance].LoginInfos getGroupUploadUrl] callback:callback];
}

-(void)uploadPersonsImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback
{
    [self uploadImage2Server:data url:[[AccountManager sharedInstance].LoginInfos getPersonUploadUrl] callback:callback];
}

-(void)uploadImage2Server:(NSData *)data url:(NSString *)url callback:(void (^)(BOOL, NSDictionary *))callback
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager POST:url parameters:@{@"b":@"1",@"c":@"1",@"ext":@".jpg"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"img" fileName:[NSString stringWithFormat:@"%lf.jpg",[[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(YES,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO,nil);
    }];
}

-(NSString *)getRootUrl
{
    if ([ObjectManager sharedInstance].cloud_url.length>0) {
        return [ObjectManager sharedInstance].cloud_url;
    }else
    {
        return rootUrl;
    }
}

@end
