//
//  UserInfoViewController.m
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "FeedbackViewController.h"
#import "UserInfoSettingViewController.h"
#import "HomeViewController.h"

#define DEFAULTBGIMGURL @"defaultBackGroundImage.png"
#define DEFAULTAVATARIMGURL @"defaultBackGroundImage.png"

@interface UserInfoViewController ()

@property (nonatomic,retain)AppDelegate *appDelegate;

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIImageView *userBackgroundImageView;
@property (nonatomic, retain) UIImageView *userAvatarImageView;
@property (nonatomic, retain) UILabel *userNickNameTextView;
@property (nonatomic, retain) NSDate *userAgeDate;
@property (nonatomic, retain) UILabel *userAgeTextView;
@property (nonatomic, retain) NSString *babyGender;
@property (nonatomic, retain) NSString *userGender;
@property (nonatomic, retain) SettingsViewController *settingsVC;
@property (nonatomic, retain) UITableView *homeTableView;
@property (nonatomic, retain) FeedbackViewController *feedbackVC;
@property (nonatomic, retain) UserInfoSettingViewController *userInfoSettingVC;

@property (nonatomic, retain) NSMutableDictionary *dict;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我";
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLeftBarButton];
    [self setupRightBarButton];
    //初始化数据
    [self initViews];
    //self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // 取出存储的数据进行初始化
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"will load persisted data from file");
        self.dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        self.userBackgroundImageView.image = [UIImage imageWithData:[self.dict valueForKey:@"bgImage"]];
        self.userAvatarImageView.image = [UIImage imageWithData:[self.dict valueForKey:@"avatarImage"]];
    } else {
        NSLog(@"file is not exist and need init self.dict");
        self.dict = [[NSMutableDictionary alloc] init];
        [self.dict setObject:UIImagePNGRepresentation([UIImage imageNamed:DEFAULTBGIMGURL]) forKey:@"bgImage"];
        [self.dict setObject:UIImagePNGRepresentation([UIImage imageNamed:DEFAULTAVATARIMGURL]) forKey:@"avatarImage"];
        [self.dict setObject:@"" forKey:@"babyGender"];
        [self.dict setObject:@"" forKey:@"userGender"];
        [self.dict setObject:@"设置昵称" forKey:@"nickName"];
        [self.dict setObject:[NSDate date] forKey:@"babyBirthday"];
        // 优化
        self.userBackgroundImageView.image = [UIImage imageWithContentsOfFile:DEFAULTBGIMGURL];
        self.userAvatarImageView.image = [UIImage imageWithContentsOfFile:DEFAULTAVATARIMGURL];
    }
    
    // 初始化
    
    self.babyGender = [self.dict valueForKey:@"babyGender"];
    self.userGender = [self.dict valueForKey:@"userGender"];
    self.userNickNameTextView.text = [self.dict valueForKey:@"nickName"];
    self.userAgeDate = [self.dict valueForKey:@"babyBirthday"];
    [self updateUserAgeDate:self.userAgeDate];


    // register callback for plist storage
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:app];

    
}


- (void)initViews{
    [self initScrollView];
    [self initUserView];
    [self initTableView];
    
}


- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-64.0f);
    _scrollView.backgroundColor  = [UIColor clearColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    
}

- (void)initUserView {
    // 显示用户头像等信息的区域
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    // 背景图片
    _userBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];

    // TODO: update bgImage to user setting or default value
    //UIImage * bgImage = [UIImage imageNamed:@"defaultBackGroundImage.png"];
    //_userBackgroundImageView.image = bgImage;
    //[_userBackgroundImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    _userBackgroundImageView.layer.masksToBounds = YES;
    
    // 用户头像
    
    CGFloat w = 90.0f; CGFloat h = w;
    CGFloat x = (self.view.frame.size.width - w) / 5;
    CGFloat y = 40.0f;
    _userAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    // TODO: update bgImage to user setting or default value
    //UIImage * avatarImage = [UIImage imageNamed:@"defaultBackGroundImage.png"];
    //_userAvatarImageView.image = avatarImage;
    [_userAvatarImageView.layer setCornerRadius:(_userAvatarImageView.frame.size.height/2)];
    [_userAvatarImageView.layer setMasksToBounds:YES];
    //[_userAvatarImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_userAvatarImageView setClipsToBounds:YES];
    _userAvatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _userAvatarImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _userAvatarImageView.layer.shadowOpacity = 0.5;
    _userAvatarImageView.layer.shadowRadius = 2.0;
    _userAvatarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userAvatarImageView.layer.borderWidth = 2.0f;
    _userAvatarImageView.backgroundColor = [UIColor whiteColor];
    
    
    // 头像旁边文字，nickname
    self.userNickNameTextView = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, 60.0f, self.view.frame.size.width-160.0f, 30.0f)];
    //userNickNameTextView.backgroundColor = [UIColor clearColor];
    self.userNickNameTextView.textColor = [UIColor whiteColor];
    //[userNickNameTextView sizeToFit];

    //self.userNickNameTextView.text = @"设置昵称";
    self.userNickNameTextView.font = [UIFont boldSystemFontOfSize:18.0f];
    // 头像旁边用户名
    self.userAgeTextView = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, 90.0f, self.view.frame.size.width-160.0f, 20.0f)];
    self.userAgeTextView.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];

    //self.userAgeTextView.text = @"设置年龄";
    self.userAgeTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    
    // 头像旁边编辑提示按钮
    UILabel *editHint = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60.0f, 120.0f, 46.0f, 16.0f)];
    editHint.textColor = [UIColor colorWithRed:230/255.0f green:233/255.0f blue:236/255.0f alpha:0.9f];
    editHint.text = @"修改资料";
    editHint.textAlignment = NSTextAlignmentCenter;
    editHint.font = [UIFont boldSystemFontOfSize:10.0f];
    [editHint.layer setCornerRadius:2.0f];
    editHint.layer.borderColor = [[UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:0.9f] CGColor];
    editHint.layer.borderWidth = 1.0f;
    
    
    // 添加信息
    [userInfoView addSubview:_userBackgroundImageView];
    [userInfoView addSubview:self.userNickNameTextView];
    [userInfoView addSubview:self.userAgeTextView];
    [userInfoView addSubview:_userAvatarImageView];
    [userInfoView addSubview:editHint];
    
    
    // 设置可点击
    userInfoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoView:)];
    [userInfoView addGestureRecognizer:singleTap];

    [self.scrollView addSubview:userInfoView];

}

- (void)initTableView {
    if(!_homeTableView){
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width,self.view.frame.size.height) style: UITableViewStyleGrouped];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.scrollEnabled = NO;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
        [_scrollView addSubview:_homeTableView];
    }
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


#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1: my collections;
    // 2: my comments;
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *ID = @"UserInfoSettingList";
    
    //创建cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"我的评论";
        }
    } else {
        cell.textLabel.text = @"给我们反馈建议";
    }
    
    
    return cell;

    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (self.feedbackVC == nil) {
            self.feedbackVC = [[FeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped];
        }
        [self.navigationController pushViewController:self.feedbackVC animated:YES];
    } else {
        if(indexPath.row == 0 ){
            HomeViewController *collectionViewController = [[HomeViewController alloc]init];
            collectionViewController.requestURL = @{@"requestRouter":@"post/mycollection"};
            collectionViewController.controllerTitle = @"我的收藏";
            [self.navigationController pushViewController:collectionViewController animated:YES];
        }else if(indexPath.row == 1){
            HomeViewController *commentViewController = [[HomeViewController alloc]init];
            commentViewController.requestURL = @{@"requestRouter":@"post/mycollection"};
            commentViewController.controllerTitle = @"我的评论";
            [self.navigationController pushViewController:commentViewController animated:YES];

        }
    }
    
    [self.homeTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)setupLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
// setup right setting button
- (void)setupRightBarButton {
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton animated:YES];
    rightBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
}

-(void)settingButtonPress:(id)sender{
    if (self.settingsVC == nil) {
        self.settingsVC = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    [self.navigationController pushViewController:self.settingsVC animated:YES];
}


// 处理点击头像信息栏事件
-(void)clickUserInfoView:(UITapGestureRecognizer *)recognizer {
    NSLog(@"click UserInfoView");
    if (self.userInfoSettingVC == nil) {
        self.userInfoSettingVC = [[UserInfoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.userInfoSettingVC setDelegate:self];
        [self.userInfoSettingVC setDict:self.dict];
    }
    [self.navigationController pushViewController:self.userInfoSettingVC animated:YES];
}

-(void)UpdateRecommendTitle{
    [self.delegate updateRecommendViewControllerTitle];
}

#pragma mark - UserInfoSettingDelegate

-(void)updateAvatarImage: (UIImage *) avatarImage {
    self.userAvatarImageView.image = avatarImage;
}

-(void)updateBackgroundImage: (UIImage *) bgImage {
    self.userBackgroundImageView.image = bgImage;
}

-(void)updateUserNickNameText: (NSString *) nicknameText {
    self.userNickNameTextView.text = nicknameText;
}

-(void)updateUserAgeDate: (NSDate *) ageDate {
    //self.userAgeTextView.text = ageDate;
    NSTimeInterval intv = -1*ageDate.timeIntervalSinceNow;
    double inDays = intv/(24*3600);
    
    if (inDays < 0) {
        self.userAgeTextView.text = @"宝贝未出生";
    } else if (inDays < 7*12) {
        int inWeeks = inDays/7;
        self.userAgeTextView.text = [NSString stringWithFormat:@"宝贝%d周",inWeeks];
    } else if (inDays < 12*30) {
        int inMonths = inDays/30;
        self.userAgeTextView.text = [NSString stringWithFormat:@"宝贝%d个月",inMonths];
    } else {
        int inYears = inDays/365;
        int restDays = (int)inDays%365;
        int inMonths = restDays/30;
        self.userAgeTextView.text = [NSString stringWithFormat:@"宝贝%d岁%d个月",inYears, inMonths];

    }

}

-(void)updateUserGender:(NSString *)gender {
    self.userGender = gender;
}

-(void)updateBabyGender:(NSString *)gender {
    self.babyGender = gender;
}


#pragma mark - misc

- (NSMutableDictionary *)formatUserInfoNeedUpload
{
    // 头像和背景图片不上传
    NSMutableDictionary *dictForUpload = [[NSMutableDictionary alloc] init];
    [dictForUpload setObject:self.babyGender forKey:@"babyGender"];
    [dictForUpload setObject:self.userGender forKey:@"userGender"];
    [dictForUpload setObject:self.userNickNameTextView.text forKey:@"nickName"];
    //[dictForUpload setObject:@"test" forKey:@"nickName"];
    [dictForUpload setObject:self.userAgeDate forKey:@"babyBirthday"];

    return dictForUpload;
}

//会出错
- (void) applicationWillResignActive:(NSNotification *)notification
{
    NSString *filePath = [self dataFilePath];
    self.dict  = [[self formatUserInfoNeedUpload] mutableCopy];
    // 目前我们将图片也存在plist里面，性能上看不出差别,也可能后续需要修改 TODO
    [self.dict setObject:UIImagePNGRepresentation(self.userBackgroundImageView.image) forKey:@"bgImage"];
    [self.dict setObject:UIImagePNGRepresentation(self.userAvatarImageView.image) forKey:@"avatarImage"];
    [self.dict writeToFile:filePath atomically:YES];
    //NSLog(@"Baby Information is persistented into plist: %@", self.dict);
}



// get plist path
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
}




@end
