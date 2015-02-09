//
//  HomeViewController.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshCustom.h"
#import "iCarousel.h"
#import "PostViewController.h"

@protocol ContentFirstViewDelegate

-(void)showHUD:(NSString *)text;
-(void)dismissHUD;

@end


@interface ContentFirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshDelegate,iCarouselDataSource, iCarouselDelegate,PostViewDelegate>

@property (nonatomic,assign)NSInteger p;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSDictionary *requestURL;
@property (nonatomic,assign) NSInteger ageChoosen;
@property (nonatomic,assign) BOOL isAgeSet;

@property (nonatomic,retain)id<ContentFirstViewDelegate> delegate;


-(void)simulatePullDownRefresh;

@end
