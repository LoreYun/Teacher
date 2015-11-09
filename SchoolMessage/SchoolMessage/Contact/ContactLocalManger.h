//
//  ContactLocalManger.h
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ObjectManager.h"

@interface ContactLocalManger : ObjectManager

+ (instancetype)sharedInstance;

-(void)uploadContactInfos:(void(^)(BOOL succeed)) callback;

-(void)DownloadContactInfos:(void(^)(BOOL succeed)) callback;

-(void)addNewContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone;

-(void)deleteContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone;

-(void)editContactInfo:(NSString *)classId name:(NSString *)name phone:(NSString *)phone;

-(void)saveLoaclContactInfos;

-(void)saveContactInfos:(NSArray *)array;

-(BOOL)IsFirst;

-(void)setFirst;

-(NSMutableArray *)getLoaclContactInfos;

@end
