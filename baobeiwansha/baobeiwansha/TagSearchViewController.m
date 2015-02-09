//
//  TagSearchViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/22.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagSearchViewController.h"
#import "TagPostTableViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface TagSearchViewController ()

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,strong)JGProgressHUD *HUD;

@end


@implementation TagSearchViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarButtonItem];
    [self initSearchBar];
    
}

-(void)initBarButtonItem{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)initSearchBar{
    
    self.searchBar = [[UISearchBar alloc]init];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbg"] forState:UIControlStateNormal];
    self.searchBar.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];


}

#pragma mark - searchBar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if([self.searchBar.text isEqualToString:@""]){
        //初始化HUD
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"请输入搜索内容";
        [self.HUD showInView:self.view];
        [self.HUD dismissAfterDelay:1.0];
        return;
    }
    [self.searchBar resignFirstResponder];
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tagsearch"} tag:self.searchBar.text];
    [self.navigationController pushViewController: tagPostViewController animated:YES];
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
