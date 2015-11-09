//
//  ContactDeleteAlertView.h
//  SchoolMessage
//
//  Created by LI on 15/2/11.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSelectedAlertViewDalegate <NSObject>

-(void) PhotoSelectedAlbum;

-(void) PhotoSelectedCarema;

@end

@interface PhotoSelectedAlertView : UIView

@property(nonatomic,weak) id<PhotoSelectedAlertViewDalegate> delegate;

-(void)show;

@end
