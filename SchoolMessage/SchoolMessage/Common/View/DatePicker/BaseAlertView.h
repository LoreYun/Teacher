//
//  BaseAlertView.h
//  WhistleActivity
//
//  Created by LI on 15/4/2.
//  Copyright (c) 2015年 ruijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL dismissEnabled;

/**
 * 自定义中间显示区域View
 */
-(UIView *)setUpContentView;

- (void)show;

- (void)hide;

-(void)hideAndDismiss:(void(^)())callback;

@end
