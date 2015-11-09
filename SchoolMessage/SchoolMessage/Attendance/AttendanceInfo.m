//
//  AttendanceInfo.m
//  SchoolMessage
//
//  Created by LI on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "AttendanceInfo.h"

@implementation AttendanceInfo
//{       "StudentId": 1,       "StudentName": "1",       "Mobile": "13755555555"     },

//@`[{"Id":"1","LateFlag":"1","Name":"张三"},{"Id":"2","LateFlag":"0","Name":"李四"},{"Id":"3","LateFlag":"0","Name":"张五"}]@`-1
-(instancetype)initWithData:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.StudentId = [dic objectForKey:@"StudentId"];
        self.StudentName = [dic objectForKey:@"StudentName"];
        self.LateFlag = NOTLATE;
    }
    return self;
}

//{"Id":"3","LateFlag":"0","Name":"张五"}]@`-1
-(NSString *)getUploadJson
{
    return [NSString stringWithFormat:@"{\"Id\":\"%@\",\"LateFlag\":\"%@\",\"Name\":\"%@\"}",self.StudentId,self.LateFlag,self.StudentName];
//  @{@"Id":self.StudentId.stringValue,@"LateFlag":self.LateFlag,@"Name":self.StudentName};
}

@end
