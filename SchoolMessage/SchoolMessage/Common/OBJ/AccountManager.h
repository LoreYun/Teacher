//
//  AccountManager.h
//  SchoolMessage
//
//  Created by wulin on 15/1/27.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "ObjectManager.h"
@class  LoginInfo;

#define USER_NAME_SAVE @"username_sm_save"

#define USER_NAME_REAL_SAVE @"username_sm_real_save"

#define USER_CLIEND_SAVE @"teacher_cid_save"

#define PWDSTRING @"AsakuraYou"

@interface AccountManager : ObjectManager

@property (nonatomic,strong) LoginInfo *LoginInfos;

@property (nonatomic,assign) BOOL loginSucced;

+ (instancetype)sharedInstance;

-(void)login:(NSString *)username pwd:(NSString *)pwd  callback:(void (^)(BOOL succeed,NSString *errorMsg))callback;

-(void)reNickname:(NSString *)nickname;


-(void)reHead:(NSString *)headUrl;

-(NSString *)getAllClassString;

@end
