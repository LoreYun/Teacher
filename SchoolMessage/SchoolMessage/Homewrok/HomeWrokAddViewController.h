//
//  HomeWrokAddViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/10.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol HomeWrokAddDelegate <NSObject>

-(void) HomeWrokAddDelegate:(NSDictionary *)dic;

@end

@interface HomeWrokAddViewController : BaseVC

@property (nonatomic,weak) id<HomeWrokAddDelegate> delegate;

@end
