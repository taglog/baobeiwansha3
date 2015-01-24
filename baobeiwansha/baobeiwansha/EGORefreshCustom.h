//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  EGORefreshCustom.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//Position of EGORefresh
typedef enum {
    EGORefreshHeader = 0,
    EGORefreshFooter,
}EGORefreshPosition;

//state of EGORefresh
typedef enum{
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
} EGOPullRefreshState;

@protocol EGORefreshDelegate;

@interface EGORefreshCustom : UIView

//属性
@property(nonatomic,assign) EGOPullRefreshState state;
@property(nonatomic,assign) EGORefreshPosition position;

//判断是上拉还是下拉
@property(nonatomic,assign) BOOL pullUp;
@property(nonatomic,assign) BOOL pullDown;


@property(nonatomic,retain) UIScrollView *scrollView;

@property(nonatomic,strong) UILabel *lastUpdatedLabel;

@property(nonatomic,strong) UILabel *statusLabel;

@property(nonatomic,strong) CALayer *arrowImage;

@property(nonatomic,strong) UIActivityIndicatorView *activityView;

@property(nonatomic,retain)id <EGORefreshDelegate> delegate;

//方法
- (id)initWithScrollView:(UIScrollView *)scrollView position:(EGORefreshPosition)position;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setState:(EGOPullRefreshState)aState;

@end

//委托的方法
@protocol EGORefreshDelegate <NSObject>

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshCustom *)view;

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshCustom *)view;

@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshCustom *)view;

@end


