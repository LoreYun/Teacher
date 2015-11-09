//
//  ChatViewController+reloadTest.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 12/18/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "ChatViewController+reloadTest.h"

@implementation ChatViewController (reloadTest)

- (void)registerBecomeActive{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didBecomeActive{
    [self.tableView reloadData];
}

@end
