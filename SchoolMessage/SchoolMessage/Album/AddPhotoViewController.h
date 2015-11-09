//
//  AddPhotoViewController.h
//  SchoolMessage
//
//  Created by LI on 15/2/4.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BaseVC.h"

@protocol AddPhotodelegate <NSObject>

-(void)AddPhoto:(NSMutableArray *)results;

@end

@interface AddPhotoViewController : BaseVC

@property (nonatomic,strong) NSMutableDictionary *classNameData;
@property (nonatomic,strong) NSString  *albumId;

@property (nonatomic,weak) id<AddPhotodelegate>  delegate;

@end
