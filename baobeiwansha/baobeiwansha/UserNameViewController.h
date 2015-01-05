//
//  UserNameViewController.h
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/4.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "UserInfoSettingViewController.h"

@protocol UserNameSettingDelegate <NSObject>

-(void)updateUserNickNameText: (NSString *) nicknameText;

@end

@interface UserNameViewController : UITableViewController

@property (nonatomic, retain) id <UserNameSettingDelegate>delegate;
@property (nonatomic, retain) NSString * orgNickName;

@end
