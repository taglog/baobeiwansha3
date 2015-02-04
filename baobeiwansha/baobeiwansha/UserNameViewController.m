//
//  UserNameViewController.m
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/4.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "UserNameViewController.h"
#import "RETableViewManager.h"

@interface UserNameViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETextItem *nameItem;

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改昵称";
    [self setupLeftBarButton];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    RETableViewSection *section1 = [RETableViewSection sectionWithHeaderTitle:@"请输入您的昵称:" footerTitle:@""];
    [self.manager addSection:section1];
    [self addButton];
    
    if (self.nameItem == nil) {
        self.nameItem = [RETextItem itemWithTitle:nil value:self.orgNickName placeholder:@""];
    }
    [section1 addItem:self.nameItem];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (RETableViewSection *)addButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    NSString * btnTitle = @"提交";
    
    
    RETableViewItem * buttonItem = [RETableViewItem itemWithTitle:btnTitle accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
        //item.title = @"提交中...";
        //[item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"Nick name is %@", self.nameItem.value);
        [self.delegate updateUserNickNameText:self.nameItem.value];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:buttonItem];
    
    return section;
}

@end
