//
//  ObjectManager.h
//  SchoolMessage
//
//  Created by LI on 15/1/26.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectManager : NSObject

+ (instancetype)sharedInstance;

-(void)requestDataOnPost:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void (^)(BOOL, NSDictionary *))callback;

-(void)requestDataOnGet:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void (^)(BOOL, NSDictionary *))callback;

-(void)uploadImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback;

-(void)uploadPersonsImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback;

-(void)uploadGroupImage2Server:(NSData *)data callback:(void (^)(BOOL, NSDictionary *))callback;

-(void)getCloudConfig:(NSString *)username callback:(void (^)(BOOL success, NSDictionary *data))callback;

-(NSString *)getRootUrl;

@end
