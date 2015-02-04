//
//  UserInfoSettingViewController.h
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "UserInfoSettingViewController.h"

@protocol UserInfoViewDelegate

-(void)updateRecommendViewControllerTitle;

@end

@interface UserInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, UserInfoSettingDelegate>

@property (nonatomic,retain) id<UserInfoViewDelegate> delegate;
@end
