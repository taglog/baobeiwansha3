//
//  ContentViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshCustom.h"

@protocol ContentCommonViewDelegate

-(void)showHUD:(NSString *)text;
-(void)dismissHUD;

@end
@interface ContentCommonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshDelegate>

@property(nonatomic,assign) NSInteger type;
@property (nonatomic,strong)NSDictionary *requestURL;
@property (nonatomic,assign) NSInteger ageChoosen;
@property (nonatomic,assign) BOOL isAgeSet;

@property(nonatomic,retain)id<ContentCommonViewDelegate> delegate;
-(id)initWithURL:(NSDictionary *)dict type:(NSInteger)index;
-(void)simulatePullDownRefresh;
@end
