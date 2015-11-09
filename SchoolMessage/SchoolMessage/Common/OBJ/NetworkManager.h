//
//  NetworkManager.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/14.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "ObjectManager.h"

@interface NetworkManager : ObjectManager

+ (instancetype)sharedInstance;

-(void) requestDataOnPost:(NSDictionary *)data ByFlag:(NSString *)flag callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  登陆
 */
-(void) loggin:(NSString *)userName pwd:(NSString *)password callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取忘记密码问题
 */
-(void) getPwdQuestion:(NSString *)chatter callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  个人信息初始化
 */
-(void) setInitPwd:(NSString *)chatter Question:(NSString *)Question Answer:(NSString*)answer pwd:(NSString *)pwd telePhone:(NSString *)tele callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

#pragma mark  ContactInfo
/**
 * 获取我的通讯录
 */
-(void)getMyHighSchoolMembersInfo:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 获取我的通讯录具体名单list
 */
-(void)getMyHighSchoolMembersInfoList:(NSString *)type contactId:(NSString *)contactId level:(NSString*)level callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

#pragma mark  Email

/**
 * 获取收件箱列表
 */
-(void)getInboxList:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 获取收件详情
 */
-(void)getInboxDetail:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 删除收件箱
 */
-(void)deleteInboxById:(NSString *)outboxId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 获取发件箱列表
 */
-(void)getOutboxList:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 获取发件箱列表
 */
-(void)deleteOutboxById:(NSString*) outboxId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 获取发件箱列表
 */
-(void)sendEmail:(NSString *)code name:(NSString *)name title:(NSString *)title content:(NSString *)content typeId:(NSString *)typeId typeName:(NSString *)typeName psotType:(NSString *)postType faleName:(NSString *)fileName recieveCode:(NSString*)recieveCode recieveName:(NSString *)recieveName realFileName:(NSString *)realFileName callback:(void(^)(BOOL succeed,NSDictionary *result))callback;


/**
 * 获取最新版本号
 */
-(void) getCurrentNewVersion:(void(^)(BOOL succeed,NSDictionary *result))callback;

#pragma mark  News
/**
 * 获取新闻列表
 */
-(void) getNewsList:(NSInteger)pageNumber callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

#pragma mark Activity 活动
/**
 *  获取精选列表
 */
-(void) getActivityEssenceList:(NSInteger)pageNumber callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取精选广告
 */
-(void) getActivityEssenceAD:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取班级待审核活动列表
 */
-(void) getActivityCheckedList:(NSInteger)pageNumber type:(NSString *)tname callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取普通列表
 */
-(void) getActivityNorList:(NSInteger)pageNumber type:(NSString *)type callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  创建活动
 */
-(void)createdActivity:(NSString *)title content:(NSString *)content fileName:(NSString *)fileName endTime:(NSString *)endTime acType:(NSString *)acType callback:(void (^)(BOOL, NSDictionary *))callback;
/**
 *  审批活动  acid 活动id   approv 1代表批准，-1代表拒绝
 */
-(void) reviewActivity:(NSString *)acId approve:(NSString *)approve callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 加入活动  acid 活动id
 */
-(void) joinActivity:(NSString *)acId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  退出活动  acid 活动id   approv 1代表批准，-1代表拒绝
 */
-(void) exitActivity:(NSString *)acId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 * 活动报名详情
 */
-(void) getActivityEnrollInfo:(NSString *)acId  pageNumber:(NSInteger)pageNumber callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

#pragma mark 文件公告
/**
 *  获取文件公告列表
 */
-(void) getNoticeList:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取个人信息
 */
-(void) getPersonInfo:(NSString*)chatter callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取个人信息
 */
-(void) getPersonInfoByNickName:(NSString*)nickName callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取群组信息
 */
-(void) getGroupInfo:(NSString*)groupId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取群组信息
 */
-(void) getNEwsOld:(NSString*)groupId callback:(void(^)(BOOL succeed,NSDictionary *result))callback;


#pragma mark photoAlbum
/**
 *  获取相册列表
 */
-(void)getClassAlbum:(NSInteger)pageNumber callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  获取相册明细
 */
-(void)getClassAlbumDetailInfo:(NSString *)albumId classId:(NSString *)classId  callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  添加相册
 */
-(void)AddClassAlbum:(NSString *)AlbumName callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *  添加照片
 */
-(void)AddClassPhoto:(NSString *)realFileName url:(NSString *)url albumID:(NSString *)albumID photoDetail:(NSString *)detail callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

    /**
  *  上传图片
  */
-(void)uploadImage2Server:(NSData *)data  callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

-(void)uploadFile2Server:(NSData *)data  callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

//-(void)setPersonHeadImage:();

-(void)updateTelephone:(NSString *)number callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

-(void)resetPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

/**
 *neirong：反馈的内容。
 fankuileixing：反馈的类型,多个以”,”分割，例：”建议,批评,随便聊聊”。
 */
-(void)feedBack:(NSString *)content type:(NSString *)type callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

-(void)initPwdInfo:(NSString *)question answer:(NSString *)answer telePhone:(NSString *)number newPwd:(NSString *)pwd callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

-(void)getClassNameById:(NSString *)classid callback:(void(^)(BOOL succeed,NSDictionary *result))callback;

@end
