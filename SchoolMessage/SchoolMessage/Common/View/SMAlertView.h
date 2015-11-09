//
//  SMAlertView.h
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAlertViewDelegate;

@interface SMAlertView : UIView

@property (nonatomic,weak) id<SMAlertViewDelegate> delegate;

/**
 * cancelButtonTitle 为nil 时候只有确定按钮
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;

-(void)show;

@end

@protocol SMAlertViewDelegate <NSObject>;

@optional

-(void)SMAlertViewonConfirm:(SMAlertView *)alertView;

-(void)SMAlertViewonCancel:(SMAlertView *)alertView;

@end