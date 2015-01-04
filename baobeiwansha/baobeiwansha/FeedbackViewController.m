//
//  FeedbackViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/28.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"

@interface FeedbackViewController ()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem;
@property (strong, readwrite, nonatomic) RETextItem *contactTextItem;
@property int delayCount;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"意见反馈";
    NSLog(@"feedback is running");
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"您的意见" footerTitle:@""];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.longTextItem = [RELongTextItem itemWithValue:nil placeholder:@"请告诉我们您的想法！感谢！"];
    self.longTextItem.cellHeight = 166;
    
    RETableViewSection *section2 = [RETableViewSection sectionWithHeaderTitle:@"您的联系方式(可选)" footerTitle:@""];
    self.contactTextItem = [RETextItem itemWithTitle:@"" value:@"" placeholder:@"您的电话或邮箱"];
    [section2 addItem:self.contactTextItem];
    
    [section addItem:self.longTextItem];
    
    
    [self.manager addSection:section];
    [self.manager addSection:section2];
    
    [self addButton];
    
    self.delayCount = 1;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RETableViewSection *)addButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
        
        if (self.longTextItem.value.length < 6) {
            [self validateFeedback:item];
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        } else if (self.delayCount > 5) {
            [self spamFeedback:item];
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self submitFeedback:item];
            //NSLog(@"longTextItem.value = %@", self.longTextItem.value);
            item.title = @"提交中...";
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
    
    return section;
}


- (void) spamFeedback: (RETableViewItem *)item
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.textLabel.text = @"您的评论太频繁了!";
    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [HUD dismissAfterDelay:3.0];
}


- (void) validateFeedback: (RETableViewItem *)item
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.textLabel.text = @"您的反馈太短了，能否增加到6个字，谢谢!";

    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [HUD dismissAfterDelay:2.0*self.delayCount];
    self.delayCount++;
}


- (void) submitFeedback: (RETableViewItem *)item
{
    // TODO: sync with server side
    self.delayCount ++;
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"提交中...";
    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString * userInfoURL = [appDelegate.rootURL stringByAppendingString:@"/serverside/feedback.php"];
    
    
    AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
    afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.longTextItem.value forKey:@"feedback"];
    [dict setObject:self.contactTextItem.value forKey:@"contact"];
    [dict setObject:appDelegate.generatedUserID forKey:@"userIdStr"];
    NSLog(@"feedback sending: %@", dict);
    
    [afnmanager POST:userInfoURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        item.title = @"提交";
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        
        
        NSLog(@"Sync successed: %@", responseObject);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUD.textLabel.text = @"提交完成";
            HUD.detailTextLabel.text = nil;
            
            HUD.layoutChangeAnimationDuration = 0.4;
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.longTextItem setValue:@""];
            [self.longTextItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
            [HUD dismiss];
            //[self.navigationController popViewControllerAnimated:YES];
        });
        //[self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync Error: %@", error);
        item.title = @"失败, 请重试";
        [HUD dismiss];
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
}




@end
