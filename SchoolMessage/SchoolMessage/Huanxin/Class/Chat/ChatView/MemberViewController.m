//
//  MemberViewController.m
//  VXiaoYuan
//
//  Created by YanShuJ on 14-12-1.
//  Copyright (c) 2014年 XianTe. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataSource;
}

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainDataSource = [[NSMutableArray alloc] init];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource =self;
    [self.view addSubview:mainTableView];
    // Do any additional setup after loading the view.
}

-(void)loadData
{
//     [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
//         
//     }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainDataSource.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
