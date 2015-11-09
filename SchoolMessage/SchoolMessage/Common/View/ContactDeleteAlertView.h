//
//  ContactDeleteAlertView.h
//  SchoolMessage
//
//  Created by LI on 15/2/11.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactDeleteAlertViewDalegate <NSObject>

-(void) ContactDeleteAlertViewOnDelete;

@end

@interface ContactDeleteAlertView : UIView

@property(nonatomic,weak) id<ContactDeleteAlertViewDalegate> delegate;

-(void)show;

@end
