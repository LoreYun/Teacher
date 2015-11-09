//
//  EducationViewController.m
//  SchoolMessage
//
//  Created by LI on 15/4/29.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "EducationViewController.h"
#import "MBProgressHUD.h"

@interface EducationViewController ()<UIWebViewDelegate>

@end

@implementation EducationViewController
{
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"津城教育";
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64)];
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    [self.view  addSubview:webView];
    webView.delegate =self;
//    NSURL *url = [NSURL URLWithString:@"http://111.160.245.75:9011/pages/xxtjs/xxtjiaoshi.html"];
//    //    NSLog(@"%@",url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self getEduUrl];
}

-(void)getEduUrl
{
    [self showHudInView:self.view hint:@""];
    [[ObjectManager sharedInstance] requestDataOnPost:@{} ByFlag:@"2001" callback:^(BOOL succeed, NSDictionary *data) {
        [self hideHud];
        if (succeed) {
            NSArray * array = [data objectForKey:@"Obj"];
            if (array.count==0) {
                [self showHint:@"操作失败，请检查网络！"];
                return ;
            }
            NSString *Url = [[array objectAtIndex:0]objectForKey:@"keyvalue"];
            if (Url.length>0) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Url]]];
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
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showHint:@"读取失败"];
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
