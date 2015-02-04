//
//  AppDelegate.m
//  baobeiwansha
//
//  Created by PanYongfeng on 14/12/31.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "MainViewController.h"
#import "PanPopNavigationController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PostViewTimeAnalytics.h"   

@interface AppDelegate ()

@property (nonatomic,strong) MainViewController *mainViewController;
@property (nonatomic,strong) IntroControll * introcontroller;
@property (nonatomic,strong) UINavigationController *initialNav;
@property (nonatomic,strong) PanPopNavigationController *mainNavigation;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //设置服务器跟目录
    
    self.rootURL = @"http://blogtest.yhb360.com/baobaowansha/";
    
    // generate UserID using VenderID
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"] == nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            self.generatedUserID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        else
            self.generatedUserID = ((__bridge NSString *)(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))));
        NSLog(@"generate UserID from UIDevice, %@", self.generatedUserID);
        [[NSUserDefaults standardUserDefaults] setObject:self.generatedUserID forKey:@"generatedUserID"];
    } else {
        self.generatedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"];
        NSLog(@"get UserID from NSUserDefaults, %@", self.generatedUserID);
    }
    
    
    
    // send information(id, and start time) to serverside
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO, update db
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString * settingURL = [self.rootURL stringByAppendingString:@"/serverside/app_statistic.php?action=app_start"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.generatedUserID forKey:@"userIdStr"];
        NSLog(@"sending statistic info: %@", dict);
        [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"App statistic update Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"App statistic update Error: %@", error);
        }];
    });
    
    //push notification setting
    [AVOSCloud setApplicationId:@"zul2tbfbwbfhtzka27mea6ozakqg3m86v2dpk349e7hh9syv"
                      clientKey:@"0mikvyvihrejfctvqarlhwvuet67pahni8fjvrse8sai4okj"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainViewController = [[MainViewController alloc]init];
    self.mainNavigation = [[PanPopNavigationController alloc]initWithRootViewController:self.mainViewController];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"mainbg"];
    self.window.layer.contents = (id) backgroundImage.CGImage;
    self.window.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
    
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"intro1.jpg"];
        
        IntroModel *model2 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"intro2.jpg"];
        
        IntroModel *model3 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"intro3.jpg"];
        
        CGRect bounds = [[UIScreen mainScreen] bounds];
        self.introcontroller = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height) pages:@[model1, model2, model3]];
        
        self.introcontroller.delegate = self;
        
        InitSettingViewController * userInfoVC = [[InitSettingViewController alloc]init];
        userInfoVC.delegate = self;
        
        self.initialNav = [[UINavigationController alloc]initWithRootViewController:userInfoVC];
    
        [self.initialNav.view addSubview:self.introcontroller];
        
        self.window.rootViewController = self.initialNav;

        
    }else{
        
        [self getBubbleFromServer];
    }


    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [PostViewTimeAnalytics disableLogPageView];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma -IntroDelegate
- (void) IntroFinished {
    
    NSLog(@"Intro finished, animated to hide");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.introcontroller.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)popInitUserInfoSetting{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.initialNav.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.initialNav removeFromParentViewController];
        [self getBubbleFromServer];
    }];

}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    NSLog(@"applicate device token is called with tocken:%@", deviceToken);
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register notification failed with code: %@", error);
}

-(void)getBubbleFromServer{
    
    //网络活动指示器
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    
    
    //请求的地址
    NSString *postRouter = @"tag/hotSix";
    NSString *postRequestUrl = [self.rootURL stringByAppendingString:postRouter];
    
    //发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager GET:postRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        NSMutableArray *bubbleTitle = [[NSMutableArray alloc]initWithCapacity:6];
        for(NSDictionary *bubbleName in responseArray){
            [bubbleTitle addObject:[bubbleName objectForKey:@"name"]];
        }
        if(bubbleTitle != nil){
            self.mainViewController.bubbleTitles = bubbleTitle;
        }else{
            self.mainViewController.bubbleTitles = @[@"创造力",@"手眼协调",@"认知",@"专注力",@"春节",@"运动"];
        }

        self.window.rootViewController = self.mainNavigation;
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
        self.mainViewController.bubbleTitles = @[@"创造力",@"手眼协调",@"认知",@"专注力",@"寒假",@"运动"];
        self.window.rootViewController = self.mainNavigation;

        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    
    
}

@end
