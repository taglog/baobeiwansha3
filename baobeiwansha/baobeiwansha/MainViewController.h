//
//  MainViewController.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubblesView.h"
#import "UserInfoViewController.h"
#import "EMHint.h"

@interface MainViewController : UIViewController<BubblesViewDelegate,UserInfoViewDelegate,EMHintDelegate>

@property (nonatomic,retain) NSArray *bubbleTitles;

-(void)resumeAnimation;

@end
