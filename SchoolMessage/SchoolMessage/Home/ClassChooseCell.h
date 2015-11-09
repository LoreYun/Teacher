//
//  ClassChooseCell.h
//  SchoolMessage
//
//  Created by LI on 15/2/2.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassChooseCell : UITableViewCell

-(void)setupViews:(NSString *)grade classString:(NSString *)classString number:(NSString *)number;

+(NSString *)identifier;

@end
