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


@interface UserInfoViewController ()

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) UIImageView *userBackgroundImageView;
@property (nonatomic, retain) UIImageView *userAvatarImageView;
@property (nonatomic, retain) SettingsViewController *settingsVC;
@property (nonatomic, retain) UITableView *homeTableView;
@property (nonatomic, retain) FeedbackViewController *feedbackVC;
@property (nonatomic, retain) UserInfoSettingViewController *userInfoSettingVC;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我";
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setupRightBarButton];
    //初始化数据
    [self initViews];
    
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
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160.0f)];
    // 背景图片
    _userBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160.0f)];

    // TODO: update bgImage to user setting or default value
    UIImage * bgImage = [UIImage imageNamed:@"defaultBackGroundImage.png"];
    
    _userBackgroundImageView.image = bgImage;
    //[_userBackgroundImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    _userBackgroundImageView.layer.masksToBounds = YES;
    
    // 用户头像
    
    CGFloat w = 90.0f; CGFloat h = w;
    CGFloat x = (self.view.frame.size.width - w) / 5;
    CGFloat y = 40.0f;
    _userAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    // TODO: update bgImage to user setting or default value
    UIImage * avatarImage = [UIImage imageNamed:@"defaultBackGroundImage.png"];
    _userAvatarImageView.image = avatarImage;
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
    UILabel *userNickNameTextView = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, 60.0f, self.view.frame.size.width-160.0f, 30.0f)];
    //userNickNameTextView.backgroundColor = [UIColor clearColor];
    userNickNameTextView.textColor = [UIColor whiteColor];
    //[userNickNameTextView sizeToFit];
    userNickNameTextView.text = @"pan_yong_feng";
    userNickNameTextView.font = [UIFont boldSystemFontOfSize:18.0f];
    // 头像旁边用户名
    UILabel *userAgeTextView = [[UILabel alloc]initWithFrame:CGRectMake(160.0f, 90.0f, self.view.frame.size.width-160.0f, 20.0f)];
    //userAgeTextView.backgroundColor = [UIColor clearColor];
    userAgeTextView.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
    userAgeTextView.text = @"1 years old";
    userAgeTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    
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
    [userInfoView addSubview:userNickNameTextView];
    [userInfoView addSubview:userAgeTextView];
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
        // TODO
    }
    
    [self.homeTableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    }
    [self.navigationController pushViewController:self.userInfoSettingVC animated:YES];
}


#pragma mark - UserInfoSettingDelegate

-(void)updateAvatarImage: (UIImage *) avatarImage {
    self.userAvatarImageView.image = avatarImage;
}

-(void)updateBackgroundImage: (UIImage *) bgImage {
    self.userBackgroundImageView.image = bgImage;
}



@end
