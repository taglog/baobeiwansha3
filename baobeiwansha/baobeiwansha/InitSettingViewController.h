//
//  InitSettingViewController.h
//  baobeiwansha
//
//  Created by 刘昕 on 15/2/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InitSettingViewDelegate

-(void)popInitUserInfoSetting;

@end
@interface InitSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic,retain) id <InitSettingViewDelegate> delegate;

@end
