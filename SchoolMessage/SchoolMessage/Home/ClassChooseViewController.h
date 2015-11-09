//
//  ClassChooseViewController.h
//  SchoolMessage
//
//  Created by wulin on 15/2/1.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM(NSInteger, ClassViewControllerType) {
    ClassNotification,//班级通知
    StudentReviews, //学生点评
    Attendance  //kaoqin
};

@interface ClassChooseViewController : BaseVC

@property (nonatomic,assign) ClassViewControllerType  viewControllerType;

@end
