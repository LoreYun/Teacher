//
//  EvaluationAddViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol EvaluationAddDelegate <NSObject>

-(void)EvaluationAddFinished:(NSDictionary *)result;

@end

@interface EvaluationAddViewController : BaseVC

@property (nonatomic,strong) NSDictionary *studentInfo;
@property (nonatomic,strong) NSDictionary *classInfos;
@property (nonatomic,strong) id<EvaluationAddDelegate> delegate;

@end
