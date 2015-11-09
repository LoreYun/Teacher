//
//  FriendInfo.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfo : NSObject
//昵称
@property (nonatomic,copy) NSString * nickName;
//头像
@property (nonatomic,copy) NSString * headPhotoUrl;
//用户账户
@property (nonatomic,copy) NSString * chatter;

@property (nonatomic) BOOL finish;

//用于登录后信息保存

@property (nonatomic,copy) NSString * anquanma;
//班级id
@property (nonatomic,copy) NSString * banjiid;
//成绩URL
@property (nonatomic,copy) NSString * chengji;
//文件URL
@property (nonatomic,copy) NSString * fileurl;
//高校ID
@property (nonatomic,copy) NSString * gaoxiaoid;
//高校名称
@property (nonatomic,copy) NSString * gaoxiaoming;
//公告文件new
@property (nonatomic,copy) NSString * gonggaowenjiannew;
//广告url
@property (nonatomic,copy) NSString * guanggao;
//教委id
@property (nonatomic,copy) NSString * jiaoweiid;
//jximgurl
@property (nonatomic,copy) NSString * jximgurl;
//课表
@property (nonatomic,copy) NSString * kebiao;
//类型
@property (nonatomic,copy) NSString * leixing;

@property (nonatomic,copy) NSString * sessionid;
//手机号
@property (nonatomic,copy) NSString * shoujihao;
//通知公告
@property (nonatomic,copy) NSString * tongzhigonggao;
//校内招聘
@property (nonatomic,copy) NSString * xiaoneiZhaoPin;
//姓名
@property (nonatomic,copy) NSString * xingming;
//新闻url  http://a.mzwxy.cn/wxyms/xinwendongtailist.jsp?bianma=
@property (nonatomic,copy) NSString * xinwenurl;
//新闻url  "http://a.mzwxy.cn/wxyms/xinwendongtaiurl/"
@property (nonatomic,copy) NSString * xinwenurlnew;
//学号
@property (nonatomic,copy) NSString * xuehao;
//学校ID
@property (nonatomic,copy) NSString * xuexiaoid;
//用户id
@property (nonatomic,copy) NSString * yonghuid;
//院系id
@property (nonatomic,copy) NSString * yuanxiid;
//招聘url
@property (nonatomic,copy) NSString * zhaopin;

//招聘url
@property (nonatomic,copy) NSString * gonghao;

//zhaopian url
@property (nonatomic,copy) NSString * zhaopian;

//-(instancetype)initByData:(NSDictionary *)dic;

/**
 *  获取级别名称
 */
-(NSString *)getLevelName;
/**
 *  获取级别id
 */
-(NSString *)getLevelId;

/**
 *  获取级 标志号
 */
-(NSString *)getLevelCode;

@end
