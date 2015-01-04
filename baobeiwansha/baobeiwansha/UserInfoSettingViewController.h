//
//  UserInfoSettingViewController.h
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "ALEInlineDatePickerViewController.h"
#import "UserNameViewController.h"

@protocol UserInfoSettingDelegate <NSObject>

-(void)updateAvatarImage: (UIImage *) avatarImage;
-(void)updateBackgroundImage: (UIImage *) bgImage;
-(void)updateUserNickNameText: (NSString *) nicknameText;
-(void)updateUserAgeDate: (NSDate *) ageDate;

@end

@interface UserInfoSettingViewController : ALEInlineDatePickerViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) id <UserInfoSettingDelegate>delegate;

@end
