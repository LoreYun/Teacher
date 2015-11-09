//
//  ContactDeleteAlertView.h
//  SchoolMessage
//
//  Created by LI on 15/2/11.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactAnycAlertViewDalegate <NSObject>

-(void) ContactAnycAlertViewUpload;

-(void) ContactAnycAlertViewDownload;

@end

@interface ContactAnycAlertView : UIView

@property(nonatomic,weak) id<ContactAnycAlertViewDalegate> delegate;

-(void)show;

@end
