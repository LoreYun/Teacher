//
//  NSDictory+CellData.m
//  SchoolMessage
//
//  Created by wulin on 15/2/8.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "NSDictory+CellData.h"

@implementation NSDictionary (CellData)

-(NSString *)getContactNstring
{
    return [NSString stringWithFormat: @"%@(%@)",[self objectForKey:@"Relation"],[self objectForKey:@"StudentName"]];
}

@end
