//
//  AppDelegate.m
//  baobeiwansha
//
//  Created by PanYongfeng on 14/12/31.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInfoViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

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
    
    UserInfoViewController* UserInfoVC = [[UserInfoViewController alloc] init];
    UINavigationController *centerNavigation = [[UINavigationController alloc] initWithRootViewController:UserInfoVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window setRootViewController:centerNavigation];
    
    
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
    

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

@end
