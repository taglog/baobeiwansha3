//
//  InitSettingViewController.m
//  baobeiwansha
//
//  Created by 刘昕 on 15/2/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "InitSettingViewController.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface InitSettingViewController ()

@property (nonatomic,retain) UIButton *boyButton;
@property (nonatomic,retain) UIButton *girlButton;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UITextField *babyNickName;
@property (nonatomic,retain) UILabel *userGender;
@property (nonatomic,retain) UILabel *babyBirthday;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) UIButton *submitButton;
@property (nonatomic,retain) UIView *toolBar;
@property (nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic,retain) UIView *checkMark;
@property (nonatomic,retain) UIView *mask;
@property (nonatomic,assign) BOOL isMaskShow;
@property (nonatomic,assign) BOOL isKeyboardShow;
@property (nonatomic,assign) BOOL isDatePickerShow;
@property (nonatomic,assign) BOOL isGirlSelected;
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;

@end

@implementation InitSettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0f green:156.0/255.0f blue:255.0/255.0f alpha:1.0f];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"完善宝宝信息";
    self.userInfoDict = [[NSMutableDictionary alloc]initWithCapacity:4];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initViews];
    
}

#pragma  mark - 初始化views
-(void)initViews{
    
    [self initTitleLabel];
    
    [self initBabyGenderButton];
    
    [self initForm];
    
    [self initSubmitButton];
    
}

-(void)initTitleLabel{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, 20)];
    label.text = @"属于您宝宝的个性推荐";
    label.textColor = [UIColor colorWithRed:53.0/255.0f green:53.0/255.0f blue:53.0/255.0f alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label];
    
    
    
    
}

-(void)initBabyGenderButton{
    
    if(!self.girlButton){
        
        self.girlButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 144, 70, 70)];
        
        [self.girlButton setBackgroundImage:[UIImage imageNamed:@"girlhead"] forState:UIControlStateNormal];
        self.girlButton.layer.cornerRadius = 35;
        self.girlButton.layer.masksToBounds = YES;
        [self.girlButton addTarget:self action:@selector(editBabyGender:) forControlEvents:UIControlEventTouchUpInside];
        self.girlButton.tag = 0;
        [self.view addSubview:self.girlButton];
        
        UILabel *girl = [[UILabel alloc]initWithFrame:CGRectMake(50, 220, 70, 20)];
        girl.text = @"女孩";
        girl.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
        girl.font = [UIFont systemFontOfSize:13.0f];
        girl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:girl];

    }
    
    if(!self.boyButton){
        
        self.boyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 144, 70, 70)];
        
        [self.boyButton setBackgroundImage:[UIImage imageNamed:@"boyhead"] forState:UIControlStateNormal];
        self.boyButton.layer.cornerRadius = 35;
        self.boyButton.layer.masksToBounds = YES;
        [self.boyButton addTarget:self action:@selector(editBabyGender:) forControlEvents:UIControlEventTouchUpInside];
        self.boyButton.tag = 1;
        [self.view addSubview:self.boyButton];
        
        UILabel *boy = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 220, 70, 20)];
        boy.text = @"男孩";
        boy.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
        boy.font = [UIFont systemFontOfSize:13.0f];
        boy.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:boy];
    }
}

-(void)initForm{
    
    if(!self.tableView){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 250, self.view.frame.size.width - 100, 200)];
        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *tableViewMask = [[UIView alloc]init];
        tableViewMask.backgroundColor =[UIColor clearColor];
        self.tableView.tableFooterView = tableViewMask;
        
        [self.view addSubview:self.tableView];
    }
}

-(void)initSubmitButton{
    
    if(!self.submitButton){
        self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 420, self.view.frame.size.width - 100, 50)];
        self.submitButton.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:209.0f/255.0f blue:77.0f/255.0f alpha:1.0];
        [self.submitButton setTitle:@"我的宝贝玩啥?" forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.submitButton.tintColor = [UIColor whiteColor];
        self.submitButton.layer.cornerRadius = 3;
        [self.submitButton addTarget:self action:@selector(syncUserInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.submitButton];
    }
    
}

#pragma  mark - 同步信息
-(void)syncUserInfo{
    
    if(![self.userInfoDict objectForKey:@"babyGender"]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"请选择宝贝性别";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:1.0];
        return;
    }
    //没有填nickname
    if(![self.userInfoDict objectForKey:@"nickName"]&&![[self.userInfoDict objectForKey:@"nickName"] isEqual:@""]){
            JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            HUD.textLabel.text = @"请填写宝贝昵称";
            [HUD showInView:self.view];
            [HUD dismissAfterDelay:1.0];
        return;
    }
    if(![self.userInfoDict objectForKey:@"userGender"]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"请选择您的身份";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:1.0];
        return;
        
    }
    if(![self.userInfoDict objectForKey:@"babyBirthday"]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"请选择宝贝生日";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:1.0];
        return;
    }
    
    
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"保存中...";
        [HUD showInView:self.view];
        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        
        NSLog(@"sending: %@", self.userInfoDict);
        
        [self.userInfoDict setObject:self.appDelegate.generatedUserID forKey:@"userIdStr"];
        
        NSString * userInfoURL = [self.appDelegate.rootURL stringByAppendingString:@"/serverside/user_info.php"];
        
        
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        [afnmanager POST:userInfoURL parameters:self.userInfoDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Sync successed: %@", responseObject);
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
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
                [self.userInfoDict writeToFile:filePath atomically:YES];
                
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Sync Error: %@", error);
            
            HUD.textLabel.text = @"网络失败，请重试";
            HUD.detailTextLabel.text = nil;
            HUD.layoutChangeAnimationDuration = 0.4;
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
            [HUD dismissAfterDelay:1];

        }];
        
    
    
    
}

#pragma mark - 选择宝宝性别
-(void)editBabyGender:(id)sender{
    
    //如果选择了女孩
    if([sender tag] == 0){
        if(self.isGirlSelected == NO){
            
            [self removeCheckMark];
        }
        [self addCheckMark:self.girlButton];
        self.isGirlSelected = YES;
        [self.userInfoDict setValue:[NSNumber numberWithInt:0] forKey:@"babyGender"];

    }
    
    //选择了男孩
    if([sender tag] == 1){
        
        if(self.isGirlSelected == YES){
            [self removeCheckMark];
        }
        [self addCheckMark:self.boyButton];
        self.isGirlSelected = NO;
        [self.userInfoDict setValue:[NSNumber numberWithInt:1] forKey:@"babyGender"];
    }
    
    
    
}
-(void)addCheckMark:(UIButton *)button{
    
    if(!self.checkMark){
        self.checkMark = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.checkMark.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIImageView *checkIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 32, 32)];
        checkIcon.image = [UIImage imageNamed:@"babyGender"];
        [self.checkMark addSubview:checkIcon];
    }
    
    [button addSubview:self.checkMark];


}

-(void)removeCheckMark{
    
    [self.checkMark removeFromSuperview];
}

#pragma mark - 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        //宝宝昵称
        if(indexPath.row == 0){
            
            if(!self.babyNickName){
                self.babyNickName = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width - 100, 45)];
                self.babyNickName.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
                self.babyNickName.placeholder = @"宝贝昵称";
                self.babyNickName.font = [UIFont systemFontOfSize:13.0f];
                self.babyNickName.returnKeyType = UIReturnKeyDone;
                self.babyNickName.delegate = self;
            }
            [cell.contentView addSubview:self.babyNickName];
            
            
            
        }
        //用户身份
        else if(indexPath.row == 1){
            
            if(!self.userGender){
                self.userGender = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width - 100, 45)];
                self.userGender.text = @"您的身份";
                self.userGender.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
                self.userGender.font = [UIFont systemFontOfSize:13.0f];
                
            }
            [cell.contentView addSubview:self.userGender];
        }
        //宝宝生日
        else if(indexPath.row == 2){
            
            if(!self.babyBirthday){
                self.babyBirthday = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width - 100, 45)];
                self.babyBirthday.text = @"宝贝生日";
                self.babyBirthday.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
                self.babyBirthday.font = [UIFont systemFontOfSize:13.0f];
            }
            [cell.contentView addSubview:self.babyBirthday];
            
        }
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 43.0f, self.view.frame.size.width - 100, 0.5f);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        
        [cell.layer addSublayer:bottomBorder];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self.babyNickName becomeFirstResponder];
        self.isKeyboardShow = YES;
        [self showMaskView];
        
    }else if(indexPath.row == 1){
        [self editUserGender];
        
    }else if(indexPath.row == 2){
        [self showDatePicker];
        [self showMaskView];
        
    }
    
}

#pragma mark - textField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showKeyboard];
    [self showMaskView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideKeyboard];
    [self dismissMaskView];
    return NO;
}

-(void)showKeyboard{
    [self.babyNickName becomeFirstResponder];
    self.isKeyboardShow = YES;
}

-(void)hideKeyboard{
    [self.babyNickName resignFirstResponder];
    self.isKeyboardShow = NO;
    [self.userInfoDict setValue:self.babyNickName.text forKey:@"nickName"];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([actionSheet.title isEqual:@"请选择您的角色"]) {
        if (buttonIndex == 0) {
            self.userGender.text = @"我是妈妈";
            self.userGender.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
            [self.userInfoDict setValue:[NSNumber numberWithInt:0] forKey:@"userGender"];
            
        } else if (buttonIndex == 1) {
            self.userGender.text = @"我是爸爸";
            self.userGender.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
            [self.userInfoDict setValue:[NSNumber numberWithInt:1] forKey:@"userGender"];
        } else if (buttonIndex == 2){
            self.userGender.text = @"其他";
            self.userGender.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
            
            [self.userInfoDict setValue:[NSNumber numberWithInt:2] forKey:@"userGender"];
        }
        
        
    }
}

//用户身份
-(void)editUserGender{
    
    UIActionSheet *userGenderSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您的角色"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"我是妈妈", @"我是爸爸", @"其他", nil];
    [userGenderSheet showInView:self.view];
    
}

#pragma mark - 设置宝宝年龄
-(void)showDatePicker{
    
    [self showMaskView];
    
    if(!self.datePicker){
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 200)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker setDate:[NSDate date]];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:6* 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
        self.toolBar.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:156.0/255.0f blue:255.0/255.0f alpha:1.0f];
        
        UIButton *datePickerDoneButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 45, 0, 30, 40)];
        [datePickerDoneButton setTitle:@"确定" forState:UIControlStateNormal];
        datePickerDoneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [datePickerDoneButton addTarget:self action:@selector(datePickerDone) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *datePickerCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 30, 40)];
        [datePickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        datePickerCancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [datePickerCancelButton addTarget:self action:@selector(datePickerCancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.toolBar addSubview:datePickerCancelButton];
        [self.toolBar addSubview:datePickerDoneButton];
        
        [self.navigationController.view addSubview:self.toolBar];
        
        [self.navigationController.view addSubview:self.datePicker];
        
    }
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 240);
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 40);
        
    } completion:^(BOOL finished) {
        
        self.isDatePickerShow = YES;
        
    }];
    
}
-(void)datePickerDone{
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *locationString=[formatter stringFromDate: [self.datePicker date]];
    self.babyBirthday.text = locationString;
    self.babyBirthday.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
    [self.userInfoDict setObject:[self.datePicker date] forKey:@"babyBirthday"];
    
    [self hideDatePicker];
    
    
}
-(void)datePickerCancel{
    
    [self hideDatePicker];
    
    
}
-(void)hideDatePicker{
    
    [self dismissMaskView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 200);
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, 30);
        
    } completion:^(BOOL finished) {
        self.isDatePickerShow = NO;
        
    }];
    
}

-(void)dismissViews{
    
    if(self.isKeyboardShow == YES){
        [self hideKeyboard];
    }
    
    if(self.isDatePickerShow == YES){
        [self hideDatePicker];
    }
    
    [self dismissMaskView];
}


-(void)showMaskView{
    
    if(!self.mask){
        self.mask = [[UIView alloc]initWithFrame:self.view.frame];
        self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViews)];
        tapGesture.cancelsTouchesInView = NO;
        
        [self.mask addGestureRecognizer:tapGesture];
        [self.navigationController.view addSubview:self.mask];
        
    }
    self.mask.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } completion:^(BOOL finished) {
        self.isMaskShow = YES;
    }];
    
}

-(void)dismissMaskView{
    
    if(self.isMaskShow == YES){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            self.mask.hidden = YES;
            self.isMaskShow = NO;
        }];
    }
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
}

@end
