//
//  SearchGroupListViewController.h
//  VXiaoYuan
//
//  Created by wulin on 14/12/16.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchGroupListDelegate;

@interface SearchGroupListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString * chatter;

@property (nonatomic,weak) id<SearchGroupListDelegate>  delegate   ;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;

@end

@protocol SearchGroupListDelegate <NSObject>

-(void)SearchGroupListOnSeleted:(NSString *)text;

@end
