//
//  HomeViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "ContentCommonViewController.h"

@protocol HomeViewDelegate

-(void)leftBarButtonItemClicked;

@end

@interface HomeViewController : ViewPagerController <ViewPagerDataSource, ViewPagerDelegate,ContentCommonViewDelegate>
@property (nonatomic,strong)NSString *controllerTitle;
@property (nonatomic,strong)NSDictionary *requestURL;
@property (nonatomic,assign) id<HomeViewDelegate> leftBarButtonItemClickedDelegate;

@end
