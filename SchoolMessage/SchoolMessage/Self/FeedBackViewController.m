//
//  FeedBackViewController.m
//  SchoolMessage
//
//  Created by LI on 15/4/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "FeedBackViewController.h"
#import "EMTextView.h"
#import "AccountManager.h"

@interface FeedBackViewController ()<UITextViewDelegate>

@property (nonatomic,strong) EMTextView * inputView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self initRightImageBar:@"fasong" action:@selector(feedBack:)];
    
    self.inputView = [[EMTextView alloc] initWithFrame:CGRectMake(8, 10, SCREEN_WIDTH-16,120)];
    self.inputView.backgroundColor = [UIColor whiteColor];
    //    self.inputView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.inputView.textColor = [UtilManager getColorWithHexString:@"#333333"];
    self.inputView.font = [UIFont systemFontOfSize:18];
    self.inputView.placeholder =@"亲，用的不爽尽管吐槽...";
    
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
}

-(void)feedBack:(id)sender
{
    if (self.inputView.text.length<=0) {
        [self showHint:@"请填写反馈内容"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    NSDictionary *dic = @{@"1":@"",@"2":self.inputView.text,@"3":[[AccountManager sharedInstance].LoginInfos getAccount]};
    [[ObjectManager sharedInstance] requestDataOnPost:dic ByFlag:@"1901" callback:^(BOOL succeed, NSDictionary * data) {
        [self hideHud];
        if (succeed) {
            NSNumber *su = [data objectForKey:S_SUCCESS];
            if (su.boolValue) {
                [self showHint:@"反馈成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showHint:@"操作失败，请检查网络！"];
            }
        }else
        {
            [self showHint:@"操作失败，请检查网络！"];
        }
    }];
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
