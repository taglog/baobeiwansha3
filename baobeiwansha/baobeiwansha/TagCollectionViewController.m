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

@interface TagCollectionViewController ()

@property (nonatomic,retain) UISearchBar *searchBar;

@property (nonatomic,retain) UICollectionView *collectionView;

@property (nonatomic,retain) NSDictionary *responseData;

@property (nonatomic,retain) NSMutableArray * sectionFoldFlags;


@end

@implementation TagCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = nil;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    if(self.index == 0){
        self.responseData =
        @{@"sectionTitle":@"潜能",
          @"sectionItems":@[
                  @{@"label":@"运动",@"image":@"football"},
                  @{@"label":@"手眼协调",@"image":@"handeye"},
                  @{@"label":@"专注力",@"image":@"focus"},
                  @{@"label":@"好奇心",@"image":@"curios"},
                  @{@"label":@"秩序与规则",@"image":@"order"},
                  @{@"label":@"沟通能力",@"image":@"talk"},
                  @{@"label":@"自信心",@"image":@"confidence"},
                  @{@"label":@"语言能力",@"image":@"language"},
                  @{@"label":@"记忆力",@"image":@"book"},
                  @{@"label":@"认知",@"image":@"acknowledge"},
                  @{@"label":@"观察能力",@"image":@"observe"},
                  @{@"label":@"逻辑思维",@"image":@"logic"},
                  @{@"label":@"情感与爱",@"image":@"heart"},
                  @{@"label":@"安全与防护",@"image":@"protection"},
                  @{@"label":@"模仿能力",@"image":@"simulate"},
                  ]
          };

            }else if(self.index == 1){
                self.responseData =
                @{@"sectionTitle":@"场景",
                  @"sectionItems":@[
                          @{@"label":@"春节",@"image":@"chun"},
                          @{@"label":@"下雪了",@"image":@"snowflake"},
                          @{@"label":@"起床",@"image":@"getup"},
                          @{@"label":@"周末",@"image":@"weekend"},
                          @{@"label":@"饭后半小时",@"image":@"aftermeal"},
                          @{@"label":@"春天",@"image":@"flower"},
                          @{@"label":@"落叶",@"image":@"leaf"},
                          @{@"label":@"公园里",@"image":@"park"},
                          @{@"label":@"小区里",@"image":@"community"},
                          @{@"label":@"和小朋友玩",@"image":@"playwithkids"},
                          @{@"label":@"月亮",@"image":@"night"},
                          @{@"label":@"下雨了",@"image":@"rainny"},
                          @{@"label":@"吃饭时",@"image":@"food"},
                          @{@"label":@"家里",@"image":@"home"},
                          @{@"label":@"宝宝生日",@"image":@"birthday"},
                          ]
                  };

            }else if (self.index == 2){
                self.responseData =
                @{@"sectionTitle":@"主题",
                  @"sectionItems":@[
                          @{@"label":@"爱上吃饭",@"image":@"food"},
                          @{@"label":@"学会排便",@"image":@"toilet"},
                          @{@"label":@"准时睡觉",@"image":@"getup"},
                          @{@"label":@"起床气",@"image":@"qichuangqi"},
                          @{@"label":@"学会整理",@"image":@"quilt"},
                          @{@"label":@"控制情绪",@"image":@"emotion"},
                          @{@"label":@"逆反期",@"image":@"sad"},
                          @{@"label":@"学会合作",@"image":@"cooperation"},
                          @{@"label":@"学会分享",@"image":@"share"},
                          @{@"label":@"不打人",@"image":@"fist"},
                          @{@"label":@"勇敢",@"image":@"brave"},
                          @{@"label":@"道歉",@"image":@"sorry"},
                          @{@"label":@"遵守规则",@"image":@"law"},
                          @{@"label":@"学会洗澡",@"image":@"bath"},
                          @{@"label":@"学翻身",@"image":@"scroll"},
                          ]
                  };

            }
    
    
    
    [self initViews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
}



-(void)initViews{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    if(!self.collectionView){
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 109) collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[TagCollectionViewCell class] forCellWithReuseIdentifier:@"ttcell"];
        
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
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
    NSArray* items =  [self.responseData objectForKey:@"sectionItems"];
    
    //    if (YES == [[self.sectionFoldFlags objectAtIndex:section] boolValue]) {
    //
    //        return 3;
    //    } else {
    //
    //        return items.count;
    //    }
    return  items.count;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)tcollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ttcell";
    
    TagCollectionViewCell *cell = [tcollectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    
    NSArray* items =  [self.responseData objectForKey:@"sectionItems"];
    //
    //    cell.label.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    //    cell.tags = [[items objectAtIndex:indexPath.row] objectForKey:@"tags"];
    
    [cell setDataWithDict:[items objectAtIndex:indexPath.row] frame:self.view.frame];
    
    //    if (indexPath.row == 2 && (YES == [[self.sectionFoldFlags objectAtIndex:indexPath.section] boolValue])) {
    //    }
    
    
    return cell;
    
}

#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置顶部的大小
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    CGSize size= CGSizeMake(self.view.frame.size.width, 50);
//    return size;
//}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    TagCollectionViewCell* cell = (TagCollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    //
    
    
}



- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    
    
}



- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Selected item of section:%d, row:%d", indexPath.section, indexPath.row);
    // TODO: add a selected mark
    NSArray* items =  [self.responseData objectForKey:@"sectionItems"];
    NSString *tag = [[items objectAtIndex:indexPath.row] valueForKey:@"label"];
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]init];
    tagPostViewController.tag = tag;
    [self.navigationController pushViewController: tagPostViewController animated:YES];
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

@end
