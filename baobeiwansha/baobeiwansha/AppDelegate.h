//
//  AppDelegate.h
//  baobeiwansha
//
//  Created by PanYongfeng on 14/12/31.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//
#import "IntroControll.h"
#import "InitSettingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IntroDelegate,InitSettingViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSString *rootURL;

@property (nonatomic, retain) NSString *generatedUserID;


@end

