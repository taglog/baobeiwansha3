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

-(void)updateBabyGender:(NSString *) gender;
-(void)updateUserGender:(NSString *) gender;

-(void)UpdateRecommendTitle;

@end

@interface UserInfoSettingViewController : ALEInlineDatePickerViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) id <UserInfoSettingDelegate>delegate;
// self.dict 在这里是只读的，写入全部放在UserInfoViewC里面，通过protocol的调用同时进行写入
@property (nonatomic, retain) NSMutableDictionary *dict;

@end
