//
//  FriendInfo.m
//  VXiaoYuan
//
//  Created by wulin on 14/12/8.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "FriendInfo.h"

@implementation FriendInfo

//-(instancetype)initByData:(NSDictionary *)dic
//{
//    self = [super init];
//    if (self) {
//        [self setUpByData:dic];
//    }
//    
//    return self;
//}

//-(void)setUpByData:(NSDictionary *)dic
//{
//    NSDictionary *info  = [dic objectForKey:V_OBJ];
//    
//    self.nickName       = [info objectForKey:V_NICHENG];
//    
//    self.headPhotoUrl = [NSString stringWithFormat:@"%@%@",[info valueForKey:V_ZHAOPIAN],[info valueForKey:V_TOUXIANGLUJING]];
//    self.anquanma       = [info objectForKey:V_ANQUANMA];
//    self.banjiid        = [info objectForKey:V_BANJIID];
//    self.chatter        = [info objectForKey:V_BIANMA];
//    self.chengji        = [info objectForKey:V_CHENGJI];
//    self.fileurl        = [info objectForKey:V_FILEURL];
//    self.gaoxiaoid      = [info objectForKey:V_GAOXIAOID];
//    self.gaoxiaoming    = [info objectForKey:V_GAOXIAOMING];
//    self.gonggaowenjiannew = [info objectForKey:V_GONGGAOWENJIANNEW];
//    self.guanggao       = [info objectForKey:V_GUANGGAO];
//    self.jiaoweiid      = [info objectForKey:V_JIAOWEIID];
//    self.jximgurl       = [info objectForKey:V_JXIMGURL];
//    self.kebiao         = [info objectForKey:V_KEBIAO];
//    self.leixing        = [info objectForKey:V_LEIXING];
//    
//    self.sessionid      = [info objectForKey:V_SESSIONID];
//    self.shoujihao      = [info objectForKey:V_SHOUJIHAO];
//    
//    self.tongzhigonggao = [info objectForKey:V_TONGZHIGONGGAO];
//    self.xiaoneiZhaoPin = [info objectForKey:V_XIAONEIZHAOPIN];
//    self.xingming       = [info objectForKey:V_XINGMING];
//    self.xinwenurl      = [info objectForKey:V_XINWENURL];
//    self.xinwenurlnew   = [info objectForKey:V_XINWENURLNEW];
//    
//    self.xuehao         = [info objectForKey:V_XUEHAO];
//    self.xuexiaoid      = [info objectForKey:V_XUEXIAOID];
//    self.yonghuid       = [info objectForKey:V_YONGHUID];
//    self.yuanxiid       = [info objectForKey:V_YUANXIID];
//    self.xuehao         = [info objectForKey:V_XUEHAO];
//    self.zhaopin        = [info objectForKey:V_ZHAOPIN];
//    
//    self.zhaopian       = [info objectForKey:V_ZHAOPIAN];
//    
//    self.gonghao        = [info objectForKey:V_GONGHAO];
//}

-(NSString *)getLevelId
{
    NSString *name = @"1";
    if ([self.leixing isEqualToString:V_XUESHENG]) {
        name = self.banjiid;
    }
    if ([self.leixing isEqualToString:V_XUESHENG]||[self.leixing isEqualToString:V_JIAOSHI]||[self.leixing isEqualToString:V_FUDAOYUAN]) {
        name = self.yuanxiid;
    }
    if ([self.leixing isEqualToString:V_GAOXIAO]) {
        name = self.xuexiaoid;
    }
    if ([self.leixing isEqualToString:V_JIAOWEI]) {
        name = self.jiaoweiid;
    }
    
    return name;
}

-(NSString *)getLevelName
{
    NSString *name = V_BANJI;
    if ([self.leixing isEqualToString:V_XUESHENG]) {
        name = V_BANJI;
    }
    if ([self.leixing isEqualToString:V_XUESHENG]||[self.leixing isEqualToString:V_JIAOSHI]||[self.leixing isEqualToString:V_FUDAOYUAN]) {
        name = V_YUANXI;
    }
    if ([self.leixing isEqualToString:V_GAOXIAO]) {
        name = V_GAOXIAO;
    }
    if ([self.leixing isEqualToString:V_JIAOWEI]) {
        name = V_JIAOWEI;
    }
    
    return name;
}

-(NSString *)getLevelCode
{
    if ([self.leixing isEqualToString:V_XUESHENG]) {
        return  self.xuehao;
    }
    
    return self.gonghao;
}

@end
