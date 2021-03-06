//
//  RecommendViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/5.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "RecommendViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface RecommendViewController ()

@property (nonatomic,strong)NSDictionary *requestURL;
//4个tab页
@property (nonatomic,strong) ContentFirstViewController *contentViewControllerFirst;
@property (nonatomic,strong) ContentCommonViewController *contentViewControllerSecond;
@property (nonatomic,strong) ContentCommonViewController *contentViewControllerThird;
@property (nonatomic,strong) ContentCommonViewController *contentViewControllerFourth;
//刷新年龄
@property (nonatomic,strong) UITableView *ageTableView;
@property (nonatomic,retain) UIButton *ageFilterButton;
@property (nonatomic,retain) UIImageView *ageFilterButtonIcon;
@property (nonatomic,retain) UILabel *ageTitleLabel;
@property (nonatomic,retain) UIButton *mask;
@property (nonatomic,assign) BOOL isAgeTableViewShow;

@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) NSUInteger activeTabIndex;
//记录上一次和下一次的月份
@property (nonatomic,assign) NSInteger beforeMonth;
@property (nonatomic,assign) NSInteger activeMonth;

@property (nonatomic,retain) UILabel *tabLabel0;
@property (nonatomic,retain) UILabel *tabLabel1;
@property (nonatomic,retain) UILabel *tabLabel2;
@property (nonatomic,retain) UILabel *tabLabel3;
//用户生日，和转换为字符串的生日
@property (nonatomic,assign) int babyBirthdayMonth;
@property (nonatomic,retain) NSString *babyBirthday;

//刷新的标识，每次更改年龄后把标识置为NO，这样切换到tab就会自动刷新
@property (nonatomic,assign) BOOL isRefreshed0;
@property (nonatomic,assign) BOOL isRefreshed1;
@property (nonatomic,assign) BOOL isRefreshed2;
@property (nonatomic,assign) BOOL isRefreshed3;

//指示层
@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@end

@implementation RecommendViewController
-(id)init{
    
    self = [super init];
    self.isFirstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initTitleView];
    
    [self initUserInfo];
    
    self.requestURL = @{@"requestRouter":@"post/category"};
    [self initContentViewController];
    
    [self initAgeTableView];
    
    [self initBarButtonItem];
    

    self.dataSource = self;
    self.delegate = self;
    
    self.isHudShow = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

#pragma mark - 第一次启动，获取用户年龄，显示在title
-(void)initUserInfo{
    
    [self getUserInfo];

    if(self.babyBirthday){
        if(self.ageTitleLabel){
            self.ageTitleLabel.text = self.babyBirthday;
        }
        self.beforeMonth = self.babyBirthdayMonth;
        self.activeMonth = self.babyBirthdayMonth;
        
    }
    
}

-(void)getUserInfo{
    
    // 取出存储的数据进行初始化
    NSString *filePath = [self dataFilePath];
    
    //如果存在userinfo.plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSDate *date = [dict objectForKey:@"babyBirthday"];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        int time = [timeStamp intValue];
        NSDate *nowDate = [NSDate date];
        NSString *nowStamp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
        int now = [nowStamp intValue];
        
        int babyBirthdayStamp = now - time;
        self.babyBirthdayMonth = floor(babyBirthdayStamp/60/60/24/30);
        
        self.babyBirthday = [self birthdayMonthToString:self.babyBirthdayMonth];
        
    }
}


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
}


//用户修改个人信息之后，要重新设置年龄和刷新状态
-(void)updateUserInfo{
    
    [self getUserInfo];
    
    if(self.ageTitleLabel){
        self.ageTitleLabel.text = self.babyBirthday;
    }
    
    self.activeMonth = self.babyBirthdayMonth;
    
    //更改目录页刷新的age
    [self resetAgeOfContentViewController:self.babyBirthdayMonth];
    
    [self.ageTableView reloadData];
    
    [self resetRefreshStatus];
    
    [self refreshActiveViewController];
    
    
}


#pragma mark - 初始化views
-(void)initTitleView{
    
    if(self.ageFilterButton == nil){
        self.ageFilterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        
        self.ageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        self.ageTitleLabel.text = @"";
        self.ageTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.ageFilterButtonIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowdown"]];
        self.ageFilterButtonIcon.tag = 1;
        self.ageFilterButtonIcon.frame = CGRectMake(95, 10, 24, 24);
        [self.ageFilterButton addTarget:self action:@selector(showAgeTableView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.ageFilterButton addSubview:self.ageFilterButtonIcon];
        [self.ageFilterButton addSubview:self.ageTitleLabel];
        
        self.navigationItem.titleView = self.ageFilterButton;
    }
    
    
    
}
-(void)initContentViewController{
    
    if (self.contentViewControllerFirst == nil) {
        self.contentViewControllerFirst = [[ContentFirstViewController alloc] init];
        self.contentViewControllerFirst.requestURL = @{@"requestRouter":@"post/discover"};
        self.contentViewControllerFirst.delegate = self;
        
    }
    if(self.contentViewControllerSecond == nil){
        
        self.contentViewControllerSecond = [[ContentCommonViewController alloc] initWithURL:self.requestURL type:1];
        self.contentViewControllerSecond.delegate = self;
        
    }
    
    if (self.contentViewControllerThird == nil) {
        
        self.contentViewControllerThird = [[ContentCommonViewController alloc] initWithURL:self.requestURL type:2];
        self.contentViewControllerThird.delegate = self;
        
    }
    if (self.contentViewControllerFourth == nil) {
        
        self.contentViewControllerFourth = [[ContentCommonViewController alloc] initWithURL:self.requestURL type:3];
        self.contentViewControllerFourth.delegate = self;
        
    }
    
}


-(void)initAgeTableView{
    
    //增加一个遮罩层
    if(self.mask == nil){
        self.mask = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.mask.hidden = YES;
        [self.mask addTarget:self action:@selector(hideAgeTableView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mask];
    }
    
    //初始化选择年龄tableview
    if(self.ageTableView == nil){
        
        self.ageTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 70, 30, 140, 200)];
        self.ageTableView.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        self.ageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.ageTableView.tag = 1;
        
        self.ageTableView.layer.cornerRadius = 5.0;
        self.ageTableView.delegate = self;
        self.ageTableView.dataSource = self;
        self.ageTableView.alpha = 0;
        self.ageTableView.hidden = YES;
        [self.view addSubview:self.ageTableView];
        self.isAgeTableViewShow = NO;
    }
    
}

-(void)initBarButtonItem{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    
    if(self.isAgeTableViewShow == YES){
        [self hideAgeTableView];
    }
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.2f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
    transition.delegate = self;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
    
}

#pragma mark - ViewPagerDataSource
//设置tab页的按钮数为4个
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

//设置4个按钮的label为：（全部，绘本，玩具，亲子）
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label;
    switch(index){
        case 0 :
            self.tabLabel0 = [[UILabel alloc]init];
            self.tabLabel0.text = @"精选";
            label = self.tabLabel0;
            break;
        case 1 :
            self.tabLabel1 = [[UILabel alloc]init];
            self.tabLabel1.text = @"绘本";
            label = self.tabLabel1;
            break;
        case 2 :
            self.tabLabel2 = [[UILabel alloc]init];
            self.tabLabel2.text = @"玩具";
            label = self.tabLabel2;
            break;
        case 3 :
            self.tabLabel3 = [[UILabel alloc]init];
            self.tabLabel3.text = @"游戏";
            label = self.tabLabel3;
            break;
    }
    
    
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    [label sizeToFit];
    
    return label;
}

//内容视图的dataSource，交给HomeTableViewController
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //初始化contentViewController
    UIViewController *viewController;
    
    //4个标签，需要4个实例
    switch (index) {
        case 0:
            viewController = self.contentViewControllerFirst;
            break;
        case 1:
            viewController = self.contentViewControllerSecond;
            break;
        case 2:
            viewController = self.contentViewControllerThird;
            break;
        case 3:
            viewController = self.contentViewControllerFourth;
            break;
        default:
            break;
    }
    
    return viewController;
}



#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 35.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return self.view.frame.size.width/4.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0] colorWithAlphaComponent:1.0];
        case ViewPagerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        default:
            return color;
    }
}


- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index{
    
    self.activeTabIndex = index;
    
    [self resetTabColor];

    if(self.beforeMonth != self.activeMonth){
        
        [self refreshActiveViewController];
        
    }
    
}


#pragma mark - 修改日期
-(void)showAgeTableView{
    
    if(self.isFirstLoad == YES){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.babyBirthdayMonth inSection:0];
        [self.ageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.isFirstLoad = NO;
        
    }
    if(self.isAgeTableViewShow == NO){
        [UIView animateWithDuration:0.2
                              delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                  self.ageFilterButtonIcon.transform = CGAffineTransformMakeRotation(-3.14f);
                                  self.ageTableView.hidden = NO;
                                  self.mask.hidden = NO;
                                  self.ageTableView.frame = CGRectMake(self.view.frame.size.width/2 - 70, 70, 140, 200);
                                  self.ageTableView.alpha = 1.0;
                                  
                                  
                              } completion:^(BOOL finished) {
                                  self.isAgeTableViewShow = YES;
                              }];}
    else{
        [self hideAgeTableView];
    }
    
}

-(void)hideAgeTableView{
    [UIView animateWithDuration:0.2
                          delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                              self.ageFilterButtonIcon.transform = CGAffineTransformMakeRotation(0);
                              
                              self.ageTableView.frame = CGRectMake(self.view.frame.size.width/2 - 70, 30, 140, 200);
                              self.ageTableView.alpha = 0.0;
                              
                              
                          } completion:^(BOOL finished) {
                              self.mask.hidden = YES;
                              self.ageTableView.hidden = YES;
                              self.isAgeTableViewShow = NO;
                              
                          }];
}

#pragma mark - ageTableViewDelegate&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  73;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *ID = @"ageList";
    
    //创建cell
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.9];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //如果是用户当前月份，显示两个点
    if(indexPath.row == self.babyBirthdayMonth){
        
        cell.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.8];
        
    }        //不是用户当前的月份
    
    cell.textLabel.text = [self birthdayMonthToString:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.8];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果选择的年龄和原来的年龄不一样，就进行刷新，如果一样就不进行刷新
    if(self.activeMonth != indexPath.row){
        
        self.beforeMonth = self.activeMonth;
        self.activeMonth = indexPath.row;
        
        //更改title上的年龄
        self.ageTitleLabel.text = [self birthdayMonthToString:indexPath.row];
        
        [self resetAgeOfContentViewController:indexPath.row];
        
        [self resetRefreshStatus];
        
        //当前active的页面先刷新
        [self refreshActiveViewController];
        
        [self hideAgeTableView];
    }
}

#pragma mark -
-(void)resetTabColor{
    
    self.tabLabel0.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel1.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel2.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel3.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    
    switch(self.activeTabIndex){
            
        case 0:
            self.tabLabel0.textColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            break;
            
        case 1:
            self.tabLabel1.textColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            break;
            
        case 2:
            self.tabLabel2.textColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];            break;
            
        case 3:
            self.tabLabel3.textColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            break;
        default:
            break;
    }
    
}

//重置状态为未刷新
-(void)resetRefreshStatus{
    
    //重新设置controller为未刷新状态，这样切换到这个页面的时候就会自动刷新
    self.isRefreshed0 = NO;
    self.isRefreshed1 = NO;
    self.isRefreshed2 = NO;
    self.isRefreshed3 = NO;
    //更改日期之后，每个controller实例的刷新参数都要恢复为2
    self.contentViewControllerFirst.p = 2;
    self.contentViewControllerSecond.p = 2;
    self.contentViewControllerThird.p = 2;
    self.contentViewControllerFourth.p = 2;
    
    
}
-(void)resetAgeOfContentViewController:(NSInteger)age{
    
    //更改目录页刷新的age
    self.contentViewControllerFirst.ageChoosen = age;
    self.contentViewControllerFirst.isAgeSet = YES;
    self.contentViewControllerSecond.ageChoosen = age;
    self.contentViewControllerSecond.isAgeSet = YES;
    self.contentViewControllerThird.ageChoosen = age;
    self.contentViewControllerThird.isAgeSet = YES;
    self.contentViewControllerFourth.ageChoosen = age;
    self.contentViewControllerFourth.isAgeSet = YES;
    
}
//刷新页面
-(void)refreshActiveViewController{
    
    switch(self.activeTabIndex){
        case 0:
            if(!self.isRefreshed0){
                [self.contentViewControllerFirst simulatePullDownRefresh];
                self.isRefreshed0 = YES;
            }
            break;
            
        case 1:
            if(!self.isRefreshed1){
                [self.contentViewControllerSecond simulatePullDownRefresh];
                self.isRefreshed1 = YES;
            }
            
            break;
            
        case 2:
            if(!self.isRefreshed2){
                [self.contentViewControllerThird simulatePullDownRefresh];
                self.isRefreshed2 = YES;
            }
            break;
            
        case 3:
            if(!self.isRefreshed3){
                [self.contentViewControllerFourth simulatePullDownRefresh];
                self.isRefreshed3 = YES;
            }
            break;
        default:
            break;
    }
}

#pragma mark - 指示层delegate
-(void)showHUD:(NSString*)text{
    //初始化HUD
    if(self.isHudShow == YES){
        [self.HUD dismissAnimated:NO];
    }
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:self.view];
    self.isHudShow = YES;
    
}
-(void)dismissHUD{
    [self.HUD dismissAfterDelay:1.0];
    self.isHudShow = NO;
}


#pragma mark - 其他
//数字月份转换字符串
-(NSString *)birthdayMonthToString:(NSInteger)month{
    NSString *string;
    if(month < 24){
        string = [NSString stringWithFormat:@"%ld个月",(long)month];
        
    }else{
        string = [NSString stringWithFormat:@"%ld岁%ld个月",month / 12,month % 12];
        if(month %12 == 0){
            string = [NSString stringWithFormat:@"%ld岁",month / 12];
        }
        
    }
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
