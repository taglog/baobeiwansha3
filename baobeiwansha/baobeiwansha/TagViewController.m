//
//  TagViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/20.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagViewController.h"
#import "TagCollectionViewController.h"
#import "TagSearchViewController.h"


@interface TagViewController ()

@property (nonatomic,retain) TagCollectionViewController *tagCollectionView0;
@property (nonatomic,retain) TagCollectionViewController *tagCollectionView1;
@property (nonatomic,retain) TagCollectionViewController *tagCollectionView2;
@property (nonatomic,retain) TagCollectionViewController *tagCollectionView3;


@property (nonatomic,assign) NSUInteger activeTabIndex;


@property (nonatomic,retain) UILabel *tabLabel0;
@property (nonatomic,retain) UILabel *tabLabel1;
@property (nonatomic,retain) UILabel *tabLabel2;
@property (nonatomic,retain) UILabel *tabLabel3;

@end

@implementation TagViewController

-(id)init{
    
    self = [super init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    [self initBarButtonItem];
    [self initSearchBar];
    [self initTagCollectionViews];
    
    self.dataSource = self;
    self.delegate = self;
    
}

-(void)initBarButtonItem{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)initSearchBar{
    
    UIButton *searchBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 240, 30)];
    [searchBarButton setBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
    [searchBarButton addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    searchBarButton.adjustsImageWhenHighlighted = NO;
    self.navigationItem.titleView = searchBarButton;

    
}

-(void)pushSearchViewController{
    TagSearchViewController  *tagSearchViewController = [[TagSearchViewController alloc]init];
    [self.navigationController  pushViewController:tagSearchViewController animated:YES];
    
}
-(void)initTagCollectionViews{
    
    if(!self.tagCollectionView0){
        self.tagCollectionView0 = [[TagCollectionViewController alloc]init];
        self.tagCollectionView0.index = 0;
    }
    if(!self.tagCollectionView1){
        self.tagCollectionView1 = [[TagCollectionViewController alloc]init];
        self.tagCollectionView1.index = 1;

    }
    if(!self.tagCollectionView2){
        self.tagCollectionView2 = [[TagCollectionViewController alloc]init];
        self.tagCollectionView2.index = 2;

    }
    if(!self.tagCollectionView3){
        self.tagCollectionView3 = [[TagCollectionViewController alloc]init];
        self.tagCollectionView3.index = 3;

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
            self.tabLabel0.text = @"热门";
            label = self.tabLabel0;
            break;
        case 1 :
            self.tabLabel1 = [[UILabel alloc]init];
            self.tabLabel1.text = @"潜能";
            label = self.tabLabel1;
            break;
        case 2 :
            self.tabLabel2 = [[UILabel alloc]init];
            self.tabLabel2.text = @"场景";
            label = self.tabLabel2;
            break;
        case 3 :
            self.tabLabel3 = [[UILabel alloc]init];
            self.tabLabel3.text = @"主题";
            label = self.tabLabel3;
            break;
    }
    
    
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    [label sizeToFit];
    
    return label;
}

//内容视图的dataSource，交给HomeTableViewController
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //初始化contentViewController
    UIViewController *viewController;
    switch (index) {
        case 0:
            viewController = self.tagCollectionView0;
            break;
        case 1:
            viewController = self.tagCollectionView1;
            break;
        case 2:
            viewController = self.tagCollectionView2;
            break;
        case 3:
            viewController = self.tagCollectionView3;
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
            return 40.0;
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

-(void)resetTabColor{
    
    self.tabLabel0.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel1.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel2.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    self.tabLabel3.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    
}


@end
