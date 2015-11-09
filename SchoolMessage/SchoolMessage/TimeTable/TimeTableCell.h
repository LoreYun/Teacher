//
//  TimeTableCell.h
//  SchoolMessage
//
//  Created by LI on 15/2/9.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableCell : UICollectionViewCell

-(void)setContent:(NSString *)content color:(NSString *)webColor;

-(void)setBlankContent:(NSString *)number;

+(NSString *)identifier;

@end
