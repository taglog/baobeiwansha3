//
//  PostViewTimeAnalytics.h
//  baobeiwansha
//
//  Created by 刘昕 on 15/2/1.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostViewTimeAnalytics : NSObject

/** 页面时长统计,记录页面开始事件。
 @param pageName 需要记录时长的view名称.
 @return void.
 */

+ (void)beginLogPageView:(NSInteger )postID;

/** 页面时长统计,记录页面结束事件。
 @param pageName 需要记录时长的view名称.
 @return void.
 */
+ (void)endLogPageView:(NSInteger )postID;

//在该页面resign active的时候，丢弃数据
+(void)disableLogPageView;
@end
