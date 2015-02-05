//
//  ContentViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshCustom.h"
#import "PostViewController.h"


@interface TagPostTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshDelegate,PostViewDelegate>

@property (nonatomic,strong)NSDictionary *requestURL;
@property (nonatomic,retain) NSString *tag;

-(id)initWithURL:(NSDictionary *)dict tag:(NSString *)tag;
-(void)simulatePullDownRefresh;

@end
