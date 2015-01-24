//
//  TagSearchViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/22.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagSearchViewController.h"

@interface TagSearchViewController ()

@property (nonatomic,retain) UISearchBar *searchBar;

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
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

@end
