//
//  BubblesView.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/6.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//
#import "OBShapedButton.h"
#import <UIKit/UIKit.h>

@protocol BubblesViewDelegate

-(void)bubbleClicked:(NSString *)tag;
-(void)moreBubbleClicked;
-(void)getRecommendedContent;
-(void)pushTagViewController;
-(void)profilePage;
@end

@interface BubblesView : UIView

@property (nonatomic,retain) id<BubblesViewDelegate> delegate;
@property (nonatomic,retain) OBShapedButton *girlButton;

-(id)initWithFrame:(CGRect)frame bubbleTitle:(NSArray *)bubbleTitles;
-(void)performShakeAnimation;
-(void)performInitializationAnimation;
-(void)pauseAnimation;
-(void)resumeAnimation;

@end
