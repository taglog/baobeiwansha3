//
//  TagCollectionViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/5.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagCollectionViewController.h"
#import "TagCollectionViewCell.h"
#import "TagPostTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface TagCollectionViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,retain) UISearchBar *searchBar;

@property (nonatomic,retain) UICollectionView *collectionView;

@property (nonatomic,retain) NSMutableArray *responseData;

@property (nonatomic,retain) NSMutableArray * sectionFoldFlags;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,retain)AppDelegate *appDelegate;

@end

@implementation TagCollectionViewController
-(id)init{
    self = [super init];
    
    self.p = 2;
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.requestURL = @{@"requestRouter":@"tag/get"};
    self.responseData = [[NSMutableArray alloc]init];
    [self initViews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}



-(void)initViews{
    
    [self initCollectionView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}



-(void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;

    if(!self.collectionView){
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[TagCollectionViewCell class] forCellWithReuseIdentifier:@"ttcell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
    }

}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshCustom alloc] initWithScrollView:self.collectionView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [self.collectionView addSubview:_refreshHeaderView];
        
    }
    
}

-(void)initRefreshFooterView{
    
    if(_refreshFooterView == nil){
        
        _refreshFooterView = [[EGORefreshCustom alloc] initWithScrollView:self.collectionView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        
    }
    
}

#pragma mark - collectionView delegate

//设置分区

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个分区上的元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.responseData.count;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)tcollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ttcell";
    
    TagCollectionViewCell *cell = [tcollectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    
    NSDictionary *item =  [self.responseData objectAtIndex:indexPath.row];
    [cell setDataWithDict:item frame:self.view.frame];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        [self initRefreshFooterView];
        [footerView addSubview:_refreshFooterView];
        reusableview = footerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
}

//设置底部的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize size= {self.view.frame.size.width,40};
    return size;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    
}



- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    
}



- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    NSDictionary *item =  [self.responseData objectAtIndex:indexPath.row];
    
    NSString *tag = [item  valueForKey:@"name"];
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tag"} tag:tag];
    
    [self.navigationController pushViewController: tagPostViewController animated:YES];
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    self.collectionView.contentOffset = CGPointMake(0, -60);
    
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //请求的地址
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            [self.responseData removeAllObjects];
            for(NSDictionary *responseDict in responseArray){
                [self.responseData addObject:responseDict];

            }
            [self.collectionView reloadData];
            self.p = 2;
        }
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.4f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_refreshHeaderView removeFromSuperview];
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

    
}

-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //请求的地址
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInteger:self.p],@"p",nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            for(NSDictionary *responseDict in responseArray){
                [self.responseData addObject:responseDict];
                
            }
            
            [self.collectionView reloadData];

            ++self.p;
            
        }else{
                
                [self.delegate showHUD:@"已经是最后一页了~"];
                [self.delegate dismissHUD];
        }
        
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    

    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
