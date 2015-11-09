//
//  ContactCell.h
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

-(void)setRelation:(NSString *)relation studentName:(NSString *)studentName;


+(NSString *)identifier;
@end
