//
//  SettingsViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/17.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "SettingsViewController.h"
#import "RETableViewManager.h"
#import "AboutUsViewController.h"
#import "BabyInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SettingsViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (retain, nonatomic) BabyInfoViewController *babyInfoVC;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"设置";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    //RETableViewSection *section1 = [RETableViewSection sectionWithHeaderTitle:@"宝贝信息" footerTitle:@""];
    RETableViewSection *section2 = [RETableViewSection sectionWithHeaderTitle:@"系统设置" footerTitle:@""];
    RETableViewSection *section3 = [RETableViewSection sectionWithHeaderTitle:@"" footerTitle:@""];
    
    //[self.manager addSection:section1];
    [self.manager addSection:section2];
    [self.manager addSection:section3];
    if (self.babyInfoVC == nil) {
        self.babyInfoVC = [[BabyInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
//    [section1 addItem:[RETableViewItem itemWithTitle:@"设置宝贝信息" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//        [item deselectRowAnimated:YES];
//        [self.navigationController pushViewController:self.babyInfoVC animated:YES];
//    }]];

    [section2 addItem:[REBoolItem itemWithTitle:@"接收推送信息" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        NSLog(@"Value: %@", item.value ? @"YES" : @"NO");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //TODO, update db
            AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
            afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString * settingURL = [appdel.rootURL stringByAppendingString:@"/serverside/setting_push_message.php"];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:item.value?@"YES":@"NO" forKey:@"enablePush"];
            [dict setObject:appdel.generatedUserID forKey:@"userIdStr"];
            NSLog(@"sending setting info: %@", dict);
            [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"App Push Setting Success: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"App Push Setting Error: %@", error);
            }];
        });
    }]];
    
    [section3 addItem:[RETableViewItem itemWithTitle:@"去APP Store评价" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        NSURL * urlStr = [NSURL URLWithString:@"http://blog.yhb360.com"];//后面为参数
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            NSLog(@"going to url");
            [[UIApplication sharedApplication] openURL:urlStr];
        }else{
            NSLog(@"can not go to url");
        }
    }]];
    
    [section3 addItem:[RETableViewItem itemWithTitle:@"关于我们" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [self.navigationController pushViewController:[[AboutUsViewController alloc] init] animated:YES];
    }]];

    
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
