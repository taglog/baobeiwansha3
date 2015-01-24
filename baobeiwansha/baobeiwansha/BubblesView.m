//
//  BubblesView.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/6.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "BubblesView.h"
#import "OBShapedButton.h"


#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

@interface BubblesView ()

@property (nonatomic,retain) NSArray *bubbleTitles;

@property (nonatomic,retain) OBShapedButton *mainButton;
@property (nonatomic,retain) OBShapedButton *bubbleButton1;
@property (nonatomic,retain) OBShapedButton *bubbleButton2;
@property (nonatomic,retain) OBShapedButton *bubbleButton3;
@property (nonatomic,retain) OBShapedButton *bubbleButton4;
@property (nonatomic,retain) OBShapedButton *bubbleButton5;
@property (nonatomic,retain) OBShapedButton *bubbleButton6;
@property (nonatomic,retain) OBShapedButton *bubbleButton7;

@property (nonatomic,retain)UIImageView *bikeView;

@end

@implementation BubblesView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self initBubbles];
    return  self;
}

-(void)initBubbles{
    
    self.bubbleTitles = @[@"创造力",@"手眼协调",@"守规则",@"专注力",@"寒假",@"爱上吃饭吧"];
    
    
    self.mainButton = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 53, self.frame.size.height/2 - 120,110,123)];
    
    [self.mainButton setBackgroundImage:[UIImage imageNamed:@"mainballoon"] forState:UIControlStateNormal];
    [self.mainButton setTitle:@"宝贝玩啥" forState:UIControlStateNormal];
  
    [self.mainButton addTarget:self action:@selector(getRecommended) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    UIImageView *mainLine;
    if(self.frame.size.height <= 480){
        mainLine = [[UIImageView alloc]initWithFrame:CGRectMake(55, 120, 63.5, 226)];
    }else{
        mainLine = [[UIImageView alloc]initWithFrame:CGRectMake(55, 120, 63.5, 267)];
    }
    
    mainLine.image = [UIImage imageNamed:@"mainbike"];
    [self.mainButton addSubview:mainLine];
    
    
    self.bubbleButton1 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 103, self.frame.size.height/2 - 210, 74, 85)];
    [self.bubbleButton1 setBackgroundImage:[UIImage imageNamed:@"balloon1"] forState:UIControlStateNormal];
    self.bubbleButton1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-3));
    self.bubbleButton1.tag = 0;
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(38, 77, 3.5, 144.5)];
    line1.image = [UIImage imageNamed:@"line1"];
    [self.bubbleButton1 addSubview:line1];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(3, 20, 74, 40)];
    title1.font = [UIFont systemFontOfSize:14.0];
    title1.text = self.bubbleTitles[0];
    title1.textColor = [UIColor whiteColor];
    title1.tag = 1;
    title1.textAlignment = NSTextAlignmentCenter;

    [self.bubbleButton1 addSubview:title1];
    
    
    
    self.bubbleButton2 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 143, self.frame.size.height/2 - 150, 70, 77.5)];
    [self.bubbleButton2 setBackgroundImage:[UIImage imageNamed:@"balloon2"] forState:UIControlStateNormal];
    self.bubbleButton2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(2));
    self.bubbleButton2.tag = 1;

    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(35, 77, 7.5, 62)];
    line2.image = [UIImage imageNamed:@"line2"];
    [self.bubbleButton2 addSubview:line2];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 70, 40)];
    title2.font = [UIFont systemFontOfSize:14.0];
    title2.text = self.bubbleTitles[1];
    title2.textColor = [UIColor whiteColor];
    title2.textAlignment = NSTextAlignmentCenter;

    [self.bubbleButton2 addSubview:title2];
    
    
    
    self.bubbleButton3 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 118, self.frame.size.height/2 - 45, 75.5, 80)];
    [self.bubbleButton3 setBackgroundImage:[UIImage imageNamed:@"balloon3"] forState:UIControlStateNormal];
    self.bubbleButton3.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(2));
    self.bubbleButton3.tag = 2;

    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 75.5, 40)];
    title3.font = [UIFont systemFontOfSize:14.0];
    title3.text = self.bubbleTitles[2];
    title3.textColor = [UIColor whiteColor];
    title3.textAlignment = NSTextAlignmentCenter;

    [self.bubbleButton3 addSubview:title3];
    
    UIImageView *cloud3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 103, self.frame.size.height/2 + 10, 78.5, 52.5)];
    cloud3.image = [UIImage imageNamed:@"cloud3"];
    [self addSubview:cloud3];
    
    self.bubbleButton4 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 + 30, self.frame.size.height/2, 72, 86)];
    [self.bubbleButton4 setBackgroundImage:[UIImage imageNamed:@"balloon4"] forState:UIControlStateNormal];
    self.bubbleButton4.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton4.tag = 3;

    UILabel *title4 = [[UILabel alloc]initWithFrame:CGRectMake(2, 20, 72, 40)];
    title4.font = [UIFont systemFontOfSize:14.0];
    title4.text = self.bubbleTitles[3];
    title4.textColor = [UIColor whiteColor];
    title4.textAlignment = NSTextAlignmentCenter;

    [self.bubbleButton4 addSubview:title4];
    
    
    UIImageView *cloud4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 + 15, self.frame.size.height/2 + 60 , 85, 59)];
    cloud4.image = [UIImage imageNamed:@"cloud4"];
    [self addSubview:cloud4];
    
    self.bubbleButton5 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 + 65, self.frame.size.height/2 - 75, 76, 76.5)];
    [self.bubbleButton5 setBackgroundImage:[UIImage imageNamed:@"balloon5"] forState:UIControlStateNormal];
    self.bubbleButton5.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-3));
    self.bubbleButton5.tag = 4;

    UILabel *title5 = [[UILabel alloc]initWithFrame:CGRectMake(3, 18, 76, 40)];
    title5.font = [UIFont systemFontOfSize:14.0];
    title5.text = self.bubbleTitles[4];
    title5.textColor = [UIColor whiteColor];
    title5.textAlignment = NSTextAlignmentCenter;
    [self.bubbleButton5 addSubview:title5];
    
    UIImageView *line5 = [[UIImageView alloc]initWithFrame:CGRectMake(19, 76, 21.5, 55.5)];
    line5.image = [UIImage imageNamed:@"line5"];
    [self.bubbleButton5 addSubview:line5];
    
    self.bubbleButton6 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 + 55, self.frame.size.height/2 - 175, 67, 75)];
    [self.bubbleButton6 setBackgroundImage:[UIImage imageNamed:@"balloon6"] forState:UIControlStateNormal];
    self.bubbleButton6.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton6.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(2));
    self.bubbleButton6.tag = 5;

    UILabel *title6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 67, 40)];
    title6.font = [UIFont systemFontOfSize:14.0];
    title6.text = self.bubbleTitles[5];
    title6.numberOfLines = 2;
    title6.textColor = [UIColor whiteColor];
    title6.textAlignment = NSTextAlignmentCenter;
    [self.bubbleButton6 addSubview:title6];
    
    UIImageView *line6 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 75, 29, 119.5)];
    line6.image = [UIImage imageNamed:@"line6"];
    [self.bubbleButton6 addSubview:line6];

    if(self.frame.size.height  <= 480 ){
        self.bubbleButton7 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 88, self.frame.size.height - 206, 74, 80)];
    }else{
        self.bubbleButton7 = [[OBShapedButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 88, self.frame.size.height - 226, 74, 80)];
    }
    [self.bubbleButton7 setBackgroundImage:[UIImage imageNamed:@"balloon7"] forState:UIControlStateNormal];
    self.bubbleButton7.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.bubbleButton7.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(2));
    UIImageView *line7 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 70, 11, 45)];
    line7.image = [UIImage imageNamed:@"line7"];
    [self.bubbleButton7 addSubview:line7];
    
    UILabel *title7 = [[UILabel alloc]initWithFrame:CGRectMake(25, 3, 74, 80)];
    title7.font = [UIFont systemFontOfSize:14.0];
    title7.text = @"更多";
    title7.textColor = [UIColor whiteColor];
    [self.bubbleButton7 addSubview:title7];
    
    
    
    
    [self.bubbleButton1 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton2 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton3 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton4 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton5 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton6 addTarget:self action:@selector(bubbleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton7 addTarget:self action:@selector(moreBubbleSelected) forControlEvents:UIControlEventTouchUpInside];

    
    [self addSubview:self.mainButton];

    [self addSubview:self.bubbleButton1];
    [self addSubview:self.bubbleButton2];
    [self addSubview:self.bubbleButton3];
    [self addSubview:self.bubbleButton4];
    [self addSubview:self.bubbleButton5];
    [self addSubview:self.bubbleButton6];
    [self addSubview:self.bubbleButton7];
    
    [self bringSubviewToFront:self.bubbleButton5];
    [self bringSubviewToFront:self.bubbleButton4];
    [self bringSubviewToFront:cloud3];
    [self bringSubviewToFront:cloud4];
    [self bringSubviewToFront:self.bubbleButton7];


}

-(void)performShakeAnimation{
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(-3))];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(3))];
  
    CABasicAnimation* rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.fromValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(2))];
    rotationAnimation1.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(-2))];
    
    CABasicAnimation* moveAnimation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton1.layer.position.x - 5, self.bubbleButton1.layer.position.y)];
    moveAnimation1.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton1.layer.position.x + 15, self.bubbleButton1.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup1 = [CAAnimationGroup animation];
    bubbleAnimationGroup1.duration = 4.0;
    bubbleAnimationGroup1.autoreverses = YES;
    bubbleAnimationGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup1.repeatCount = HUGE_VALF;
    bubbleAnimationGroup1.removedOnCompletion = NO;
    bubbleAnimationGroup1.animations = [NSArray arrayWithObjects:rotationAnimation,moveAnimation1,nil];
    
    [self.bubbleButton1.layer addAnimation:bubbleAnimationGroup1 forKey:@"bubbleShake"];
    
    CABasicAnimation* moveAnimation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton2.layer.position.x - 5, self.bubbleButton2.layer.position.y)];
    moveAnimation2.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton2.layer.position.x + 10, self.bubbleButton2.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup2 = [CAAnimationGroup animation];
    bubbleAnimationGroup2.duration = 4.0;
    bubbleAnimationGroup2.autoreverses = YES;
    bubbleAnimationGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup2.repeatCount = HUGE_VALF;
    bubbleAnimationGroup2.removedOnCompletion = NO;
    bubbleAnimationGroup2.animations = [NSArray arrayWithObjects:rotationAnimation1,moveAnimation2,nil];
    
    [self.bubbleButton2.layer addAnimation:bubbleAnimationGroup2 forKey:@"bubbleShake"];
    
    CABasicAnimation* moveAnimation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation3.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton3.layer.position.x - 5, self.bubbleButton3.layer.position.y + 3)];
    moveAnimation3.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton3.layer.position.x + 10, self.bubbleButton3.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup3 = [CAAnimationGroup animation];
    bubbleAnimationGroup3.duration = 4.0;
    bubbleAnimationGroup3.autoreverses = YES;
    bubbleAnimationGroup3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup3.repeatCount = HUGE_VALF;
    bubbleAnimationGroup3.removedOnCompletion = NO;
    bubbleAnimationGroup3.animations = [NSArray arrayWithObjects:rotationAnimation1,moveAnimation3,nil];
    
    [self.bubbleButton3.layer addAnimation:bubbleAnimationGroup3 forKey:@"bubbleShake"];

    
    CABasicAnimation* moveAnimation4 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation4.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton4.layer.position.x -3, self.bubbleButton4.layer.position.y)];
    moveAnimation4.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton4.layer.position.x + 8, self.bubbleButton4.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup4 = [CAAnimationGroup animation];
    bubbleAnimationGroup4.duration = 4.0;
    bubbleAnimationGroup4.autoreverses = YES;
    bubbleAnimationGroup4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup4.repeatCount = HUGE_VALF;
    bubbleAnimationGroup4.removedOnCompletion = NO;
    bubbleAnimationGroup4.animations = [NSArray arrayWithObjects:moveAnimation4,nil];
    
    [self.bubbleButton4.layer addAnimation:bubbleAnimationGroup4 forKey:@"bubbleShake"];
    
    
    CABasicAnimation* moveAnimation5 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation5.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton5.layer.position.x -5, self.bubbleButton5.layer.position.y)];
    moveAnimation5.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton5.layer.position.x + 10, self.bubbleButton5.layer.position.y - 4)];
    
    CAAnimationGroup *bubbleAnimationGroup5 = [CAAnimationGroup animation];
    bubbleAnimationGroup5.duration = 4.0;
    bubbleAnimationGroup5.autoreverses = YES;
    bubbleAnimationGroup5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup5.repeatCount = HUGE_VALF;
    bubbleAnimationGroup5.removedOnCompletion = NO;
    bubbleAnimationGroup5.animations = [NSArray arrayWithObjects:rotationAnimation,moveAnimation5,nil];
    
    [self.bubbleButton5.layer addAnimation:bubbleAnimationGroup5 forKey:@"bubbleShake"];
    
    
    CABasicAnimation* moveAnimation6 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation6.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton6.layer.position.x - 3, self.bubbleButton6.layer.position.y - 6)];
    moveAnimation6.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton6.layer.position.x + 15, self.bubbleButton6.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup6 = [CAAnimationGroup animation];
    bubbleAnimationGroup6.duration = 4.0;
    bubbleAnimationGroup6.autoreverses = YES;
    bubbleAnimationGroup6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup6.repeatCount = HUGE_VALF;
    bubbleAnimationGroup6.removedOnCompletion = NO;
    bubbleAnimationGroup6.animations = [NSArray arrayWithObjects:rotationAnimation1,moveAnimation6,nil];
    
    [self.bubbleButton6.layer addAnimation:bubbleAnimationGroup6 forKey:@"bubbleShake"];
    
    CABasicAnimation* moveAnimation7 = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation7.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton7.layer.position.x - 3, self.bubbleButton7.layer.position.y - 6)];
    moveAnimation7.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton7.layer.position.x + 15, self.bubbleButton7.layer.position.y)];
    
    CAAnimationGroup *bubbleAnimationGroup7 = [CAAnimationGroup animation];
    bubbleAnimationGroup7.duration = 4.0;
    bubbleAnimationGroup7.autoreverses = YES;
    bubbleAnimationGroup7.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroup7.repeatCount = HUGE_VALF;
    bubbleAnimationGroup7.removedOnCompletion = NO;
    bubbleAnimationGroup7.animations = [NSArray arrayWithObjects:rotationAnimation1,moveAnimation7,nil];
    
    [self.bubbleButton7.layer addAnimation:bubbleAnimationGroup7 forKey:@"bubbleShake"];
    
    CABasicAnimation* rotationAnimationMainButton = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimationMainButton.fromValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(0))];
    rotationAnimationMainButton.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(2.2))];
    
    CABasicAnimation* moveAnimationMainButton = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimationMainButton.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.mainButton.layer.position.x , self.mainButton.layer.position.y)];
    moveAnimationMainButton.toValue = [NSValue valueWithCGPoint:CGPointMake(self.mainButton.layer.position.x + 10, self.mainButton.layer.position.y - 3)];
    
    CAAnimationGroup *bubbleAnimationGroupMainButton = [CAAnimationGroup animation];
    bubbleAnimationGroupMainButton.duration = 4.0;
    bubbleAnimationGroupMainButton.autoreverses = YES;
    bubbleAnimationGroupMainButton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bubbleAnimationGroupMainButton.repeatCount = HUGE_VALF;
    bubbleAnimationGroupMainButton.removedOnCompletion = NO;
    bubbleAnimationGroupMainButton.animations = [NSArray arrayWithObjects:rotationAnimationMainButton,moveAnimationMainButton,nil];
    
    [self.mainButton.layer addAnimation:bubbleAnimationGroupMainButton forKey:@"bubbleShake"];
    
    

    
}
-(void)performInitializationAnimation{
    
    float initialDuration = 2.0;
    
    CABasicAnimation *initAnimationOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    initAnimationOpacity.fromValue = [NSNumber numberWithFloat:0.0];
    initAnimationOpacity.toValue = [NSNumber numberWithFloat:1.0];
    
    
    CABasicAnimation *initAnimationMove1 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove1.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton1.layer.position.x - 10, self.bubbleButton1.layer.position.y + 50)];
    initAnimationMove1.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton1.layer.position.x - 5, self.bubbleButton1.layer.position.y )];
    
    CAAnimationGroup *initAnimationGroup1 = [CAAnimationGroup animation];
    initAnimationGroup1.duration = initialDuration;
    initAnimationGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup1.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove1,nil];
    
    [self.bubbleButton1.layer addAnimation:initAnimationGroup1 forKey:@"bubbleAppear"];
    
    
    CABasicAnimation *initAnimationMove2 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove2.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton2.layer.position.x - 30, self.bubbleButton2.layer.position.y + 50)];
    initAnimationMove2.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton2.layer.position.x - 5, self.bubbleButton2.layer.position.y)];

    CAAnimationGroup *initAnimationGroup2 = [CAAnimationGroup animation];
    initAnimationGroup2.duration = initialDuration;
    initAnimationGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup2.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove2,nil];
    
    [self.bubbleButton2.layer addAnimation:initAnimationGroup2 forKey:@"bubbleAppear"];
    
    CABasicAnimation *initAnimationMove3 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove3.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton3.layer.position.x + 20, self.bubbleButton3.layer.position.y + 20)];
    initAnimationMove3.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton3.layer.position.x - 5, self.bubbleButton3.layer.position.y + 3)];
    
    CAAnimationGroup *initAnimationGroup3 = [CAAnimationGroup animation];
    initAnimationGroup3.duration = initialDuration;
    initAnimationGroup3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup3.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove3,nil];
    
    [self.bubbleButton3.layer addAnimation:initAnimationGroup3 forKey:@"bubbleAppear"];

    CABasicAnimation *initAnimationMove4 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove4.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton4.layer.position.x - 20, self.bubbleButton4.layer.position.y + 20)];
    initAnimationMove4.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton4.layer.position.x - 3, self.bubbleButton4.layer.position.y )];
    
    CAAnimationGroup *initAnimationGroup4 = [CAAnimationGroup animation];
    initAnimationGroup4.duration = initialDuration;
    initAnimationGroup4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup4.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove4,nil];
    
    [self.bubbleButton4.layer addAnimation:initAnimationGroup4 forKey:@"bubbleAppear"];

    CABasicAnimation *initAnimationMove5 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove5.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton5.layer.position.x + 20, self.bubbleButton5.layer.position.y + 60)];
    initAnimationMove5.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton5.layer.position.x - 5, self.bubbleButton5.layer.position.y )];
    
    CAAnimationGroup *initAnimationGroup5 = [CAAnimationGroup animation];
    initAnimationGroup5.duration = initialDuration;
    initAnimationGroup5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup5.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove5,nil];
    
    [self.bubbleButton5.layer addAnimation:initAnimationGroup5 forKey:@"bubbleAppear"];

    CABasicAnimation *initAnimationMove6 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove6.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton6.layer.position.x - 10, self.bubbleButton6.layer.position.y + 50)];
    initAnimationMove6.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton6.layer.position.x - 3, self.bubbleButton6.layer.position.y - 6)];
    
    CAAnimationGroup *initAnimationGroup6 = [CAAnimationGroup animation];
    initAnimationGroup6.duration = initialDuration;
    initAnimationGroup6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup6.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove6,nil];
    
    [self.bubbleButton6.layer addAnimation:initAnimationGroup6 forKey:@"bubbleAppear"];
    
    CABasicAnimation *initAnimationMove7 = [CABasicAnimation animationWithKeyPath:@"position"];
    initAnimationMove7.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton7.layer.position.x + 20, self.bubbleButton7.layer.position.y + 20)];
    initAnimationMove7.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bubbleButton7.layer.position.x - 3, self.bubbleButton7.layer.position.y - 6)];
    
    CAAnimationGroup *initAnimationGroup7 = [CAAnimationGroup animation];
    initAnimationGroup7.duration = initialDuration;
    initAnimationGroup7.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    initAnimationGroup7.animations = [NSArray arrayWithObjects:initAnimationOpacity,initAnimationMove7,nil];
    
    [self.bubbleButton7.layer addAnimation:initAnimationGroup7 forKey:@"bubbleAppear"];

    

}

-(void)pauseAnimation{

    [self pauseLayer:self.bubbleButton1.layer];
    [self pauseLayer:self.bubbleButton2.layer];
    [self pauseLayer:self.bubbleButton3.layer];
    [self pauseLayer:self.bubbleButton4.layer];
    [self pauseLayer:self.bubbleButton5.layer];
    [self pauseLayer:self.bubbleButton6.layer];
    [self pauseLayer:self.bubbleButton7.layer];
    [self pauseLayer:self.mainButton.layer];

}
-(void)resumeAnimation{

    [self resumeLayer:self.bubbleButton1.layer];
    [self resumeLayer:self.bubbleButton2.layer];
    [self resumeLayer:self.bubbleButton3.layer];
    [self resumeLayer:self.bubbleButton4.layer];
    [self resumeLayer:self.bubbleButton5.layer];
    [self resumeLayer:self.bubbleButton6.layer];
    [self resumeLayer:self.bubbleButton7.layer];
    [self resumeLayer:self.mainButton.layer];
    
}

-(void)pauseLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


-(IBAction)bubbleSelected:(id)sender{
    
    [self.delegate bubbleClicked:self.bubbleTitles[[sender tag]]];
}

-(void)moreBubbleSelected{
    [self.delegate moreBubbleClicked];
}

-(void)getRecommended{
    [self.delegate getRecommendedContent];
}
@end
