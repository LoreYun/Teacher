//
//  SchoolMsgHeader.h
//  SchoolMessage
//
//  Created by LI on 15/1/26.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#ifndef SchoolMessage_SchoolMsgHeader_h
#define SchoolMessage_SchoolMsgHeader_h

#import "NetworkManager.h"

#import "UtilManager.h"

#import "RosterManager.h"

#import "FriendInfo.h"

#import "ObjectManager.h"

#import "AccountManager.h"

#import "LoginInfo.h"

#define APP_VERSION @"Teacher"

#define APP_ACCOUNT_TYPE @"Teacher"

#define photoUrl [[AccountManager sharedInstance].LoginInfos getTouxiangUrl]
#define imageUrl [[AccountManager sharedInstance].LoginInfos getImageUrl]
#define fileUrl  [[AccountManager sharedInstance].LoginInfos getFileUrl]

#define rootCloudUrl  @"http://111.160.245.75:10000/IndexHandler.ashx"
//productor
//#define rootUrl  @"http://111.160.245.75:9010/IndexHandler.ashx"
//#define fileUrl [[AccountManager sharedInstance].LoginInfos getFileUrl]
//#define uploadImageUrl @"http://111.160.245.75:9010/"
//#define uploadFileUrl @"http://www.mzwxy.cn/wxyws/servlet/UploadFile"
//#define uploadHeadUrl @"http://www.mzwxy.cn/wxyws/servlet/UploadTouxiang"

//test
#define rootUrl  @"http://111.160.245.75:8888/wxyws/servlet/WxyServlet"
#define adUrl @"http://111.160.245.75:8888/wxyms/gonggaowenjianurl/"
#define uploadImageUrl @"http://111.160.245.75:8888/wxyws/servlet/UploadImage"
#define uploadFileUrl @"http://111.160.245.75:8888/wxyws/servlet/UploadFile"
#define uploadHeadUrl @"http://111.160.245.75:8888/wxyws/servlet/UploadTouxiang"

//friend key

#define V_OBJ           @"Obj"
#define V_T             @"T"
#define V_SUCCESS       @"IsSuccess"


#define S_OBJ           @"Obj"
#define S_T             @"T"
#define S_SUCCESS       @"IsSuccess"
#define S_Msg           @"Msg"
#define S_NICKNAME       @"NickName"
#define S_TOUXIANG       @"Touxiang"
#define S_ACCOUNT        @"Account"
//#define S_NICKNAME       @"NickName"

#define V_ANQUANMA          @"anquanma"
#define V_BANJIID           @"banjiid"
#define V_BIANMA            @"bianma"
#define V_CHENGJI           @"chengji"
#define V_FILEURL           @"fileurl"
#define V_GAOXIAOID         @"gaoxiaoid"
#define V_GAOXIAOMING       @"gaoxiaoming"
#define V_GONGGAOWENJIANNEW  @"gonggaowenjiannew"
#define V_GUANGGAO          @"guanggao"
#define V_JIAOWEIID         @"jiaoweiid"
#define V_JXIMGURL          @"jximgurl"
#define V_KEBIAO            @"kebiao"
#define V_LEIXING           @"leixing"
#define V_NICHENG           @"nicheng"
#define V_RESULT            @"result"
#define V_SESSIONID         @"sessionid"
#define V_SHOUJIHAO         @"shoujihao"
#define V_TONGZHIGONGGAO    @"tongzhigonggao"
#define V_TOUXIANGLUJING    @"touxianglujing"
#define V_XIAONEIZHAOPIN    @"xiaoneiZhaoPin"
#define V_XINGMING          @"xingming"
#define V_XINWENURL         @"xinwenurl"
#define V_XINWENURLNEW      @"xinwenurlnew"
#define V_XUEHAO            @"xuehao"
#define V_XUEXIAOID         @"xuexiaoid"
#define V_YONGHUID          @"yonghuid"
#define V_YUANXIID          @"yuanxiid"
#define V_XUEXIAOID         @"xuexiaoid"
#define V_XUEXIAOID         @"xuexiaoid"
#define V_ZHAOPIAN          @"zhaopian"
#define V_ZHAOPIN           @"zhaopin"
#define V_GONGHAO           @"gonghao"

#define V_XUESHENG          @"xs"
#define V_BANJI             @"banji"
#define V_YUANXI            @"yuanxi"
#define V_JIAOSHI           @"js"
#define V_GAOXIAO           @"gaoxiao"
#define V_JIAOWEI           @"jiaowei"
#define V_FUDAOYUAN         @"fdy"

#define S_ClASSID               @"ClassId"
#define S_CLASSNAME             @"ClassName"
#define S_GRADEID               @"GradeId"
#define S_GRADENAME             @"GradeName"
#define S_STUDENT_COUNT         @"StudentCount"
#define S_SUBJECT_ID            @"SubjectId"
#define S_SUBJECT_NAME          @"SubjectName"
#define S_MOBILE                @"Mobile"
#define S_STUDENT_ID            @"StudentId"
#define S_STUDENT_NAME          @"StudentName"
#define S_XUHAO                 @"XueHao"



#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
#define iphone5 [UIScreen mainScreen].bounds.size.height > 500


#endif
