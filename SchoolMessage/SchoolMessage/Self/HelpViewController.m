//
//  HelpViewController.m
//  SchoolMessage
//
//  Created by LI on 15/4/28.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "HelpViewController.h"
#import "MBProgressHUD.h"

@interface HelpViewController ()<UIWebViewDelegate>

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64)];
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    [self.view  addSubview:webView];
    webView.delegate =self;
    NSURL *url = [NSURL URLWithString:[[AccountManager sharedInstance].LoginInfos getTeacherHelpUrl]];
    //    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
