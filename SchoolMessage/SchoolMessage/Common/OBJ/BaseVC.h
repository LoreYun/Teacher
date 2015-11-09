//
//  BaseVC.h
//  SchoolMessage
//
//  Created by LI on 15-1-23.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

-(void)initRightTitleBar:(NSString *)title action:(SEL)action;

-(void)initRightImageBar:(NSString *)image action:(SEL)action;

@end
