//
//  ContentViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "TagPostTableViewController.h"
#import "HomeTableViewCell.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"

@interface TagPostTableViewController ()


@property (nonatomic,retain) UITableView *homeTableView;

@property (nonatomic,strong) NSMutableArray *homeTableViewCell;
//刷新 view
@property (nonatomic,retain) EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain) EGORefreshCustom *refreshFooterView;

@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property(nonatomic,strong) JGProgressHUD *HUD;

@property (nonatomic,strong) UILabel *noDataAlert;

@property (nonatomic,strong) UIView *tableViewMask;

@property (nonatomic,assign) NSInteger p;
@end

@implementation TagPostTableViewController

-(id)initWithURL:(NSDictionary *)dict tag:(NSString *)tag{
    self.p = 2;
    self = [super init];
    self.requestURL = dict;
    self.tag = tag;
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.tag;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = nil;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    if(self){
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //初始化数据
        [self initViews];
        
    }
}
-(void)popViewController{
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.2f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
    transition.delegate = self;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)initViews{
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

//初始化tableView
-(void)initTableView{
    
    
    if(_homeTableView == nil){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height - 24);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        
        self.tableViewMask = [UIView new];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_homeTableView];
    
    
}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshCustom alloc] initWithScrollView:_homeTableView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [_homeTableView addSubview:_refreshHeaderView];
        
    }
    
}
-(void)initRefreshFooterView{
    
    if(_refreshFooterView == nil){
        
        _refreshFooterView = [[EGORefreshCustom alloc] initWithScrollView:_homeTableView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        
        _homeTableView.tableFooterView = _refreshFooterView;
    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    
    self.tableViewMask = [UIView new];
    self.tableViewMask.backgroundColor =[UIColor clearColor];
    _homeTableView.tableFooterView = self.tableViewMask;
    
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
    
    [cell setDataWithDict:self.homeTableViewCell[indexPath.row] frame:self.view.frame];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    PostViewController *post = [[PostViewController alloc] init];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.homeTableViewCell[indexPath.row] objectForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"/post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {

        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        if(responseDict != (id)[NSNull null]){
            [post initViewWithDict:responseDict];
            post.indexPath = indexPath;
            post.delegate = self;
        }else{
            [post noDataAlert];
        }
        [post dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [post dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
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
    _homeTableView.contentOffset = CGPointMake(0, -60);
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    postRouter = @"post/tag";
    
    postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",self.tag,@"tag",nil];
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        [self.homeTableViewCell removeAllObjects];
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
                [self.noDataAlert removeFromSuperview];
            }
            
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
            if([self.homeTableViewCell count]>4){
                if(self.tableViewMask){
                    self.tableViewMask = nil;
                    [self.tableViewMask removeFromSuperview];
                }
                [self initRefreshFooterView];
                
            }else{
                //去除分割线
                _homeTableView.tableFooterView = self.tableViewMask;
                
            }
            
            [_homeTableView reloadData];

        }else{
            [self showHUD:@"没有内容~"];
            [self dismissHUD];
            [self showNoDataAlert];
           
        }
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
        
    }];
    
    
}
-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    
    postRouter = @"post/getTableByTag";
    
    postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",self.tag,@"tag",nil];
    
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray == (id)[NSNull null]){
            //如果是最后一页
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
            [self showHUD:@"已经是最后一页了~"];
            [self dismissHUD];
            
        }else{
            
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
            [_homeTableView reloadData];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            self.p++;
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    
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

-(void)showHUD:(NSString *)text{
    //显示hud层
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:self.view];
}
-(void)dismissHUD{
    [self.HUD dismiss];
}


@end
