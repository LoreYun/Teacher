//
//  AlbumManager.m
//  SchoolMessage
//
//  Created by wulin on 15/2/1.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AlbumManager.h"

@implementation AlbumManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)getAlbumList:(NSInteger)page classId:(NSString *)classId gradeId:(NSString *)gradeId callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic = @{@"1":classId,@"2":gradeId,@"3":@"15",@"4":[NSString stringWithFormat:@"%ld",(long)page]};
    [self requestDataOnPost:dic ByFlag:@"503" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];
}

-(void)createAlbum:(NSString *)albumName teacherId:(NSString *)teacherId teacherName:(NSString *)teacherName classId:(NSString *)classId className:(NSString *)calssName gradeId:(NSString *)gradeId gradeName:(NSString *)gradeName fileName:(NSString *)fileName fullName:(NSString *)fullName callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic = @{@"1":albumName,@"2":teacherId,@"3":teacherName,@"4":classId,@"5":calssName,@"6":gradeId,@"7":gradeName,@"8":fileName,@"9":fullName};
    [self requestDataOnPost:dic ByFlag:@"501" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];
}

-(void)addPhotoInAlbum:(NSString *)teacherId teacherName:(NSString *)teacherName classId:(NSString *)classId className:(NSString *)calssName gradeId:(NSString *)gradeId gradeName:(NSString *)gradeName fileName:(NSString *)fileName fullName:(NSString *)fullName describtion:(NSString *)describtion albumId:(NSString *)albumId callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic = @{@"2":teacherId,@"3":teacherName,@"4":classId,@"5":calssName,@"6":gradeId,@"7":gradeName,@"8":fileName,@"9":fullName,@"10":describtion,@"11":albumId};
    [self requestDataOnPost:dic ByFlag:@"502" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];
}

-(void)getAlbumDetailList:(NSInteger)page albumId:(NSString *)albumId callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSDictionary *dic = @{@"1":albumId,@"2":@"15",@"3":[NSString stringWithFormat:@"%ld",(long)page]};
    [self requestDataOnPost:dic ByFlag:@"504" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];
}

-(void)deletePhotoInAlbum:(NSMutableArray *)photoIds callback:(void (^)(BOOL, NSDictionary *))callback
{
    NSString *ids = @"";
    for (NSString *photoId in photoIds) {
        ids = [NSString stringWithFormat:@"%@,%@",ids,photoId];
    }
    ids = [ids substringFromIndex:1];
    [self requestDataOnPost:@{@"1":ids} ByFlag:@"505" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];
}

-(void)setAlbumCover:(NSString *)albumId fileName:(NSString *)fileName fullName:(NSString *)fullName callback:(void (^)(BOOL, NSDictionary *))callback
{
    [self requestDataOnPost:@{@"1":albumId,@"2":fileName,@"3":fullName} ByFlag:@"506" callback:^(BOOL succeed, NSDictionary * data) {
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            callback(su.boolValue,data);
        }else
        {
            callback(NO,nil);
        }
    }];

    
}

@end
