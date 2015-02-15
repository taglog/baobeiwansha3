//
//  RecommendViewController.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/5.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "ContentFirstViewController.h"
#import "ContentCommonViewController.h"

@interface RecommendViewController : ViewPagerController <ViewPagerDataSource, ViewPagerDelegate,ContentCommonViewDelegate,ContentFirstViewDelegate,UITableViewDataSource,UITableViewDelegate>

-(void)updateUserInfo;

@end
