//
//  UserInfoSettingViewController.m
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//


// 0代表女孩，1代表男孩
#import "InitUserInfoSettingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "AppDelegate.h"



@interface InitUserInfoSettingViewController () <UINavigationControllerDelegate, UIActionSheetDelegate, UserNameSettingDelegate>

@property (nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@property (nonatomic, strong) NSString *nickNameString;
@property (nonatomic, strong) NSString *babyGenderString;
@property (nonatomic, strong) NSString *userGenderString;
@property (nonatomic, strong) UserNameViewController *userNameVC;
@property (nonatomic, strong) NSDate *birthdayDate;
@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation InitUserInfoSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善信息";
    self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    self.datePickerPossibleIndexPaths = @[self.firstDatePickerIndexPath];
    
    self.dict = [[NSMutableDictionary alloc] init];
    [self.dict setObject:@"" forKey:@"babyGender"];
    [self.dict setObject:@"" forKey:@"userGender"];
    [self.dict setObject:@"" forKey:@"nickName"];
    [self.dict setObject:[NSDate date] forKey:@"babyBirthday"];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // 初始化上次保存的值
    [self setDate:[self.dict objectForKey:@"babyBirthday"] forIndexPath:self.firstDatePickerIndexPath];
    self.birthdayDate = [self dateForIndexPath:self.firstDatePickerIndexPath];

    [self initSubmitButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSubmitButton{
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, 40)];
    [submitButton setBackgroundColor:[UIColor redColor]];
    [submitButton setTitle:@"完成" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(syncBabyInfoSetting) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = submitButton;
}

-(void)syncBabyInfoSetting{
    
    BOOL isCompleted = ![[self.dict valueForKey:@"babyGender"] isEqual: @""]&&![[self.dict valueForKey:@"nickName"] isEqual:@""]&&![[self.dict valueForKey:@"nickName"] isEqual:@"请输入昵称"]&&![[self.dict valueForKey:@"userGender"] isEqual: @""];
    if (!isCompleted) {
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"有未完成的选项";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:1.0];
    }else{
        
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"保存中...";
    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        
    NSLog(@"sending: %@", self.dict);

    [self.dict setObject:self.appDelegate.generatedUserID forKey:@"userIdStr"];

    NSString * userInfoURL = [self.appDelegate.rootURL stringByAppendingString:@"/serverside/user_info.php"];
    
    
    AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
    afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
    [afnmanager POST:userInfoURL parameters:self.dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Sync successed: %@", responseObject);
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userHasLogged"];
            HUD.textLabel.text = @"保存成功";
            HUD.detailTextLabel.text = nil;
            
            HUD.layoutChangeAnimationDuration = 0.4;
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
            [self.delegate popInitUserInfoSetting];
            
            //加入
            NSString *filePath = [self dataFilePath];
            [self.dict writeToFile:filePath atomically:YES];

        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync Error: %@", error);
        [HUD dismiss];
        
    }];
    
    
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSInteger numberOfRows = [super tableView:tableView numberOfRowsInSection:section] ;
    
    return numberOfRows+4;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"UserInfoSettingID";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"您的昵称";
            if (_nickNameString == nil) {
                _nickNameString = [self.dict objectForKey:@"nickName"];
            }
            cell.detailTextLabel.text = _nickNameString;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"宝贝性别";
            if (_babyGenderString == nil) {
                _babyGenderString = [self.dict objectForKey:@"babyGender"];
            }
            cell.detailTextLabel.text = _babyGenderString;
        } else if (indexPath.row == 2){
            cell.textLabel.text = @"您的性别";
            if (_userGenderString == nil) {
                _userGenderString = [self.dict objectForKey:@"userGender"];
            }
            cell.detailTextLabel.text = _userGenderString;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"宝贝出生日期";
            
            NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeStyle = NSDateFormatterNoStyle;
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            [dateFormatter setLocale:cnLocale];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:self.birthdayDate];
            
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (rowHeight == 0) {
        rowHeight = self.tableView.rowHeight;
    }
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
        if (indexPath.row == 0) {
            if (_userNameVC == nil) {
                _userNameVC = [[UserNameViewController alloc] initWithStyle:UITableViewStyleGrouped];
                _userNameVC.delegate = self;
                _userNameVC.orgNickName = [self.dict objectForKey:@"nickName"];
            }
            [self.navigationController pushViewController:_userNameVC animated:YES];
            
        } else if (indexPath.row == 1) {
            [self editBabyGender];
        } else if (indexPath.row == 2) {
            [self editUserGender];
        } else if (indexPath.row == 3) {
            //宝宝生日
            [self.tableView scrollToRowAtIndexPath:self.firstDatePickerIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)dateChanged:(UIDatePicker *)sender{
    
    [self.dict setObject:sender.date forKey:@"babyBirthday"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.firstDatePickerIndexPath];
    
    self.birthdayDate = sender.date;
    NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [dateFormatter setLocale:cnLocale];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:self.birthdayDate];
    
}



#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([actionSheet.title  isEqual: @"请选择宝贝性别"]) {
        if (buttonIndex == 0) {
            self.babyGenderString = @"女孩";
            [self.dict setValue:[NSNumber numberWithInt:0] forKey:@"babyGender"];
        } else if (buttonIndex == 1){
            self.babyGenderString = @"男孩";
            [self.dict setValue:[NSNumber numberWithInt:1] forKey:@"babyGender"];

        }
        [self.tableView reloadData];

    } else if ([actionSheet.title isEqual:@"请选择您的角色"]) {
        if (buttonIndex == 0) {
            self.userGenderString = @"我是妈妈";
            [self.dict setValue:[NSNumber numberWithInt:0] forKey:@"userGender"];

        } else if (buttonIndex == 1) {
            self.userGenderString = @"我是爸爸";
            [self.dict setValue:[NSNumber numberWithInt:1] forKey:@"userGender"];

        } else if (buttonIndex == 2){
            self.userGenderString = @"其他";
            [self.dict setValue:[NSNumber numberWithInt:2   ] forKey:@"userGender"];

        }
        [self.tableView reloadData];

    }
}




#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}



// misc functions
- (void)editBabyGender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"请选择宝贝性别"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"女孩", @"男孩", nil];
    [choiceSheet showInView:self.view];
}

- (void)editUserGender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您的角色"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"我是妈妈", @"我是爸爸", @"其他", nil];
    [choiceSheet showInView:self.view];
    
}



-(void)updateUserNickNameText: (NSString *) nicknameText {
    self.nickNameString = nicknameText;
    [self.tableView reloadData];
    [self.dict setValue:self.nickNameString forKey:@"nickName"];

}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
}





@end
