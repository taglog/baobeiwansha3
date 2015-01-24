//
//  EGORefreshTableHeaderView.m
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
//  EGORefreshCustom.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "EGORefreshCustom.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define TEXT_COLOR	 [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]

@interface EGORefreshCustom (Private)

-(void)setState:(EGOPullRefreshState)aState;

@end

@implementation EGORefreshCustom

@synthesize delegate = _delegate;

-(id)initWithScrollView:(UIScrollView *)scrollView position:(EGORefreshPosition)position{
    _scrollView = scrollView;
    _position = position;
    
    if (_position == EGORefreshHeader) {
        
        self = [self initWithFrame:CGRectMake(0.0f, 10.0f - _scrollView.bounds.size.height, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    }else{
        
        self = [self initWithFrame:CGRectMake(0, 0,_scrollView.frame.size.width,40.0f)];
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        //状态label
        UILabel *label = [[UILabel alloc] init];
        if(_position == EGORefreshHeader){
            label.frame = CGRectMake(0.0f, frame.size.height - 60.0f, self.frame.size.width, 20.0f);
        }
        else{
            label.frame = CGRectMake(0.0f, frame.size.height - 7.0f, self.frame.size.width, 20.0f);
        }
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        //开始加载的指示
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if(_position == EGORefreshHeader){
            view.frame = CGRectMake(frame.size.width/2.0f - 10.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        }
        else{
            view.frame = CGRectMake(frame.size.width/2.0f - 10.0f, frame.size.height - 30.0f, 20.0f, 20.0f);
        }
        
        [self addSubview:view];
        _activityView = view;
        
        
        [self setState:EGOOPullRefreshNormal];
        
    }
    return self;
}

-(void)setState:(EGOPullRefreshState)aState{
    
    switch (aState) {
        case EGOOPullRefreshPulling:
            
            _statusLabel.text = NSLocalizedString(@"释放刷新", @"Release to refresh status");
            break;
        case EGOOPullRefreshNormal:
            if(_position == EGORefreshHeader){
                _statusLabel.text = NSLocalizedString(@"下拉刷新", @"Pull down to refresh status");
            }else{
                 _statusLabel.text = NSLocalizedString(@"上拉刷新", @"Pull down to refresh status");
            }
            [_activityView stopAnimating];
            
            break;
        case EGOOPullRefreshLoading:
            
            _statusLabel.text = NSLocalizedString(@"正在加载", @"Loading Status");
            [_activityView startAnimating];
            
            break;
        default:
            break;
    }
    
    _state = aState;

}

#pragma mark - 滚动相关的方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == EGOOPullRefreshLoading) {
        
        if(_position == EGORefreshHeader){
            
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }
        else{
            
            CGFloat offset = MAX(scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
        }
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        BOOL pullingCondition = NO;
        BOOL normalCondition = NO;
        
        if(_position == EGORefreshHeader){
            pullingCondition = (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f);
            normalCondition = (scrollView.contentOffset.y < -65.0f);
        }else{
            CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height;
            pullingCondition = ((y < (scrollView.contentSize.height+65.0f)) && (y > scrollView.contentSize.height));
            normalCondition = (y > (scrollView.contentSize.height+65.0f));
        }
        
        if (_state == EGOOPullRefreshPulling && pullingCondition && !_loading) {
            
            [self setState:EGOOPullRefreshNormal];
        } else if (_state == EGOOPullRefreshNormal && normalCondition && !_loading) {
            
            [self setState:EGOOPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    BOOL condition = NO;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if(_position == EGORefreshHeader){
        condition = (scrollView.contentOffset.y <= - 45.0f);
        insets = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        _pullDown = condition ? YES : NO;
    }else{
        CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentSize.height;
        condition = (y > 45.0f);
        insets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        _pullUp = condition ? YES : NO;
    }
    
    if (condition && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = insets;
        [UIView commitAnimations];
        
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    [self setState:EGOOPullRefreshNormal];
    
}


@end
