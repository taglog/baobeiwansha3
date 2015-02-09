//
//  PostViewTimeAnalytics.m
//  baobeiwansha
//
//  Created by 刘昕 on 15/2/1.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "PostViewTimeAnalytics.h"
#import <Mach/mach_time.h>
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

@interface PostViewTimeAnalytics ()

@end

@implementation PostViewTimeAnalytics

+(void)beginLogPageView:(NSInteger)postID{
    
    //获取plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"postAnalytics.plist"];
    
    NSMutableDictionary  *postAnalytics;
    //如果plist文件存在，将这次数据存储进
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        postAnalytics = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        
    }else{
        
        postAnalytics = [[NSMutableDictionary alloc]init];
        
    }
    
    //获取当前时间戳
    NSString *appearStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    int appearTime = [appearStamp intValue];
    
    [postAnalytics setObject:[NSNumber numberWithInt:appearTime]forKey:@"appearStamp"];
    
    [postAnalytics setObject:[NSNumber numberWithInteger:postID] forKey:@"postID"];
    
    
    [postAnalytics writeToFile:filePath atomically:YES];
    
    
}

+(void)endLogPageView:(NSInteger)postID{
    
    //获取plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"postAnalytics.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSMutableDictionary  *postAnalytics = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        //如果postID与上次存入的一致并且disappearStamp还没有设置
        if([postAnalytics objectForKey:@"postID"] == [NSNumber numberWithInteger:postID]){
            //获取当前时间戳
            NSString *disappearStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            int disappearTime = [disappearStamp intValue];
            
            [postAnalytics setObject:[NSNumber numberWithInt:disappearTime] forKey:@"disappearStamp"];
            
            
            //把数据发送到后台
            
            
            //网络活动指示器
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            //请求的地址
            NSString *postRouter = @"post/analytic";
            NSString *postRequestUrl = [appDelegate.rootURL stringByAppendingString:postRouter];
            
            NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:appDelegate.generatedUserID,@"userIdStr",postAnalytics,@"postView",nil];
            
            //发送请求
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer.timeoutInterval = 20;
            [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
                NSLog(@"%@",responseObject);
                
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];
            
            
            
        }
        
    }
    
}
+(void)disableLogPageView{

    //获取plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"postAnalytics.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSMutableDictionary  *postAnalytics = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
            
        [postAnalytics removeAllObjects];
        [postAnalytics writeToFile:filePath atomically:YES];
       

    }

}


@end
