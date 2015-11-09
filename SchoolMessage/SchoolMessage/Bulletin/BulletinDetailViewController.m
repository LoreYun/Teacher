//
//  BulletinDetailViewController.m
//  SchoolMessage
//
//  Created by wulin on 15/2/4.
//  Copyright (c) 2015年 whwy. All rights reserved.
//

#import "BulletinDetailViewController.h"

@interface BulletinDetailViewController ()<UIWebViewDelegate>

@end

@implementation BulletinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    scrollview.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:scrollview];
//    
//    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 15,SCREEN_WIDTH-34,21)];
//    titlelabel.font = [UIFont boldSystemFontOfSize:20];
//    titlelabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
//    titlelabel.textAlignment = NSTextAlignmentCenter;
//    titlelabel.text = [self.bulletinDetail objectForKey:@"NoticeTitle"];
//    [scrollview addSubview:titlelabel];
//    
//    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(17,44,SCREEN_WIDTH-17,16)];
//    timelabel.font = [UIFont boldSystemFontOfSize:12];
//    timelabel.textColor = [UtilManager getColorWithHexString:@"#6D6E71"];
////    timelabel.textAlignment = NSTextAlignmentRight;
//    timelabel.text = [NSString stringWithFormat:@"%@  %@",[self.bulletinDetail objectForKey:@"FaQiRenName"],[self.bulletinDetail objectForKey:@"CreateTime"]];
//    [scrollview addSubview:timelabel];
//    
//    
//    NSString * content = [self.bulletinDetail objectForKey:@"NoticeContent"];
//    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
//    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,71,SCREEN_WIDTH-30,size.height)];
//    contentLabel.font = [UIFont systemFontOfSize:18];
//    contentLabel.textColor = [UtilManager getColorWithHexString:@"#333333"];
//    contentLabel.numberOfLines = 0;
//    contentLabel.textAlignment = NSTextAlignmentJustified;
//    contentLabel.text = content;
//    [scrollview addSubview:contentLabel];
//    [scrollview setContentSize:CGSizeMake(SCREEN_WIDTH, size.height+78+5)];
    
    UIWebView *webview =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webview.scalesPageToFit = YES;
    webview.delegate = self;
    [self.view addSubview:webview];
    
    NSString *root = [[ObjectManager sharedInstance] getRootUrl];
    
    root = [root substringToIndex:[root rangeOfString:@"/" options:NSBackwardsSearch].location+1];
    
    NSString *url =  [[root stringByAppendingString:@"/"] stringByAppendingString:[self.bulletinDetail objectForKey:@"HtmlURL"]];
    NSLog(@"url %@",url);
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [webview loadRequest:req];
    [self showHudInView:self.view hint:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
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
