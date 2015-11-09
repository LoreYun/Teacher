//
//  AlbumManager.h
//  SchoolMessage
//
//  Created by wulin on 15/2/1.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ObjectManager.h"

@interface AlbumManager : ObjectManager

+ (instancetype)sharedInstance;
/**
 * 获取相册列表
 */
-(void)getAlbumList:(NSInteger)page classId:(NSString *)classId gradeId:(NSString *)gradeId callback:(void(^)(BOOL succeed,NSDictionary *data))callback;
/**
 * 创建相册
 */
-(void)createAlbum:(NSString *)albumName teacherId:(NSString *)teacherId teacherName:(NSString *)teacherName classId:(NSString *)classId className:(NSString *)calssName gradeId:(NSString *)gradeId gradeName:(NSString *)gradeName fileName:(NSString *)fileName fullName:(NSString *)fullName callback:(void(^)(BOOL succeed,NSDictionary *data))callback;

/**
 * 添加照片
 */
-(void)addPhotoInAlbum:(NSString *)teacherId teacherName:(NSString *)teacherName classId:(NSString *)classId className:(NSString *)calssName gradeId:(NSString *)gradeId gradeName:(NSString *)gradeName fileName:(NSString *)fileName fullName:(NSString *)fullName describtion:(NSString *)describtion albumId:(NSString *)albumId callback:(void(^)(BOOL succeed,NSDictionary *data))callback;
/**
 * 获取相册图片列表
 */
-(void)getAlbumDetailList:(NSInteger)page albumId:(NSString *)albumId callback:(void (^)(BOOL, NSDictionary *))callback;
/**
 * delete相册图片列表
 */
-(void)deletePhotoInAlbum:(NSMutableArray *)photoIds callback:(void (^)(BOOL, NSDictionary *))callback;

/**
 * 设置相册封面
 */
-(void)setAlbumCover:(NSString *)albumId fileName:(NSString *)fileName fullName:(NSString *)fullName callback:(void (^)(BOOL, NSDictionary *))callback;

@end
