//
//  AboutUsViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/28.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "AboutUsViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface AboutUsViewController ()
@property (nonatomic, retain) JGProgressHUD *HUD;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://61.174.9.214/www/index.php/Home/othersetting/aboutus.html"]];
    [webView setDelegate:self];
    [self.view addSubview: webView];
    
    [webView loadRequest:request];
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


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"加载中...";
    [self.HUD showInView:self.view];
    self.HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.HUD dismiss];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"didFailLoadWithError:%@", error);
    self.HUD.textLabel.text = @"加载失败";
    self.HUD.layoutChangeAnimationDuration = 0.4;
    self.HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
}

@end
