//
//  HomeViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ContentFirstViewController.h"
#import "AFNetworking.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "AppDelegate.h"
#import "HomeTableViewCell.h"


@interface ContentFirstViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,strong)NSMutableArray *homeTableViewCell;

@property (nonatomic, retain) UIScrollView * scrollView;

@property (nonatomic,retain) UITableView *homeTableView;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;
@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,strong)UILabel *noDataAlert;

@property (nonatomic,strong)UIView *tableViewMask;

@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, strong) NSMutableArray *carouselItems;

@property (nonatomic, retain) NSDictionary* responseData;

@property (nonatomic,retain) AppDelegate *appDelegate;


@property (nonatomic,strong) JGProgressHUD *HUD;
@property (nonatomic,assign) BOOL isHudShow;


@end

@implementation ContentFirstViewController

-(id)init{
    
    self = [super init];
    
    if(self){
        
        self.p = 2;
        //变量设置,如果不放在init里面，在view没有load的时候是不能执行刷新页面操作的，所以在同步完用户年龄进行读取的时候，会报错
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //轮播栏的参数，暂时不用
    self.responseData =
    @{@"banner":
          @{@"imgurl":@"chrismas.jpg", @"title":@"圣诞节",
            @"imgurl":@"winter.jpeg", @"title":@"冬天",
            @"imgurl":@"newyear.png", @"title":@"春节",
            @"imgurl":@"halloween.jpeg", @"title":@"万圣节"
            }
      };
    
    //初始化views
    [self initViews];
    
}

#pragma mark 初始化Views
-(void)initViews{
    
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    
    [self initScrollView];
    //[self initCarousel];
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

-(void)initScrollView{
    
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 104.0f)];
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
        _scrollView.backgroundColor  = [UIColor whiteColor];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    
}

-(void)initCarousel{
    
    self.carouselItems = [NSMutableArray array];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0,110, self.view.frame.size.width, 50)];
    textView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    
    UILabel *carouselTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,0, self.view.frame.size.width, 50)];
    carouselTextLabel.text = @"圣诞节专题";
    carouselTextLabel.textColor = [UIColor whiteColor];
    carouselTextLabel.font = [UIFont systemFontOfSize:15.0f];
    
    imageView1.image = [UIImage imageNamed:@"chrismas.jpg"];
    [textView addSubview:carouselTextLabel];
    [imageView1 addSubview:textView];
    [self.carouselItems addObject:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView2.image = [UIImage imageNamed:@"winter.jpeg"];
    [self.carouselItems addObject:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView3.image = [UIImage imageNamed:@"newyear.png"];
    [self.carouselItems addObject:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView4.image = [UIImage imageNamed:@"halloween.jpeg"];
    [self.carouselItems addObject:imageView4];
    
    
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width,160)];
    self.carousel.type = 1;
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.pagingEnabled = YES;
    self.carousel.clipsToBounds = YES;
    [self.carousel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_scrollView addSubview:self.carousel];
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(carouselSlide:) userInfo:nil repeats:YES];
    
    
}

-(void)initTableView{
    
    if(_homeTableView == nil){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 160, self.view.frame.size.width,self.view.frame.size.height);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.scrollEnabled = NO;
        
        self.tableViewMask = [[UIView alloc]init];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
        [_scrollView addSubview:_homeTableView];
    }
    
}


-(void)carouselSlide:(NSTimer*)timer{
    static int i = 0;
    if(i>3)
    {
        i=0;
    }
    [self.carousel scrollToItemAtIndex:i animated:YES];
    i++;
}


//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshCustom alloc] initWithScrollView:_scrollView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [_scrollView addSubview:_refreshHeaderView];
        
    }
    
}
-(void)initRefreshFooterView{
    
    if(_refreshFooterView == nil){
        
        _refreshFooterView = [[EGORefreshCustom alloc] initWithScrollView:_scrollView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
        [_scrollView addSubview:_refreshFooterView];
        
    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    if(self.tableViewMask == nil){
        self.tableViewMask = [[UIView alloc]init];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
    }
    
    if(self.noDataAlert == nil){
        self.noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 40.0f)];
        self.noDataAlert.text = @"暂时没有内容哦~";
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.font = [UIFont systemFontOfSize:14.0f];
        
        [_homeTableView addSubview:self.noDataAlert];
    }
    
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.homeTableViewCell.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    @try {
        [cell setDataWithDict:self.homeTableViewCell[indexPath.row] frame:self.view.frame];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    PostViewController *post = [[PostViewController alloc] init];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.homeTableViewCell[indexPath.row] objectForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        if(responseDict != (id)[NSNull null]){
            
            [post initViewWithDict:responseDict];
            post.indexPath = indexPath;
            post.delegate = self;
            
        }else{
            [post noDataAlert];
        }
        [post dismissHUD];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 
       
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [post dismissHUD];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
    [post showHUD];
    [self.navigationController pushViewController:post animated:YES];
    
}


-(void)updateCollectionCount:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[self.homeTableView cellForRowAtIndexPath:indexPath];
    
    NSInteger collectionNumber;
    //收藏成功，需+1
    if(type == 1){
        collectionNumber = [[self.homeTableViewCell[indexPath.row] objectForKey:@"collection_count"]integerValue] + 1;
    }else{
        collectionNumber = [[self.homeTableViewCell[indexPath.row] objectForKey:@"collection_count"]integerValue] - 1;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                 self.homeTableViewCell[indexPath.row]];
    [dict setObject:[NSNumber numberWithInteger:collectionNumber] forKey:@"collection_count"];
    [self.homeTableViewCell replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [cell updateCollectionCount:collectionNumber];
    
}


#pragma mark EGORefreshReloadData
- (void)reloadTableViewDataSource{
    
    //下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        [self performPullDownRefresh];
    }
    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        [self performPullUpRefresh];
    }
}

-(void)simulatePullDownRefresh{
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    //不用动画，这样在拉动到下方的时候不会有上滑得效果,或者判断一下现在的contentoffset，超过一屏的情况就不显示动画？
    _scrollView.contentOffset = CGPointMake(0, -64);
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    //网络活动指示器
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    //请求的地址
    postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //是否选择了年龄，如果没有选择，就默认读取用户在数据库的年龄
    if(self.isAgeSet){
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",[NSNumber numberWithInteger:self.ageChoosen],@"age",nil];
    }else{
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",nil];
    }
    
    //发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
            }
            
            [self.homeTableViewCell removeAllObjects];

            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
                
            }
            if([self.homeTableViewCell count]>4){
                
                _homeTableView.frame = CGRectMake(0, self.carousel.frame.size.height, self.view.frame.size.width,[self.homeTableViewCell count]*100);
                
                _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.carousel.frame.size.height + _homeTableView.frame.size.height);
                
                [self initRefreshFooterView];
                
            }else{
                //去除分割线
                _homeTableView.tableFooterView = self.tableViewMask;
                _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            
            [_homeTableView reloadData];
            self.p = 2;
            
        }else{
            
            [self showHUD:@"没有内容~"];
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            [self dismissHUD];
            [self showNoDataAlert];
            
        }
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
    
    
}
-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    
    //请求的地址
    postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(self.isAgeSet){
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",[NSNumber numberWithInteger:self.ageChoosen],@"age",nil];
    }else{
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",nil];
        
    }
    
    //发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray == (id)[NSNull null]){
            
            //如果是最后一页
            [self showHUD:@"已经是最后一页了"];
            [self  dismissHUD];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
            
        }else{
            
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
            _homeTableView.frame = CGRectMake(0, self.carousel.frame.size.height, self.view.frame.size.width,[self.homeTableViewCell count]*100);
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.carousel.frame.size.height + [self.homeTableViewCell count]*100 );
            _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
            
            [_homeTableView reloadData];
            self.p++;
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self  showHUD:@"网络请求失败~"];
        [self  dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
    
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    
}

#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshCustom *)view{
    
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshCustom *)view{
    
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshCustom *)view{
    
    return [NSDate date];
    
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.carouselItems count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        UIImageView *imageView = [self.carouselItems objectAtIndex:index];
        [view addSubview:imageView];
        
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [self.carouselItems[(NSUInteger)index] stringValue];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}


#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //NSNumber *item = (self.carouselItems)[(NSUInteger)index];
    //NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    //NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
