//
//  PanPopNavigationController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/19.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "PanPopNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface PanPopNavigationController ()
{
    CGPoint startTouchPoint;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *viewControllerList;
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,retain) UIImageView *lastScreenShotView;

@end

@implementation PanPopNavigationController

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    
    self = [super initWithRootViewController:rootViewController];
    
    if(self){
        self.allowPanPop = YES;
        self.viewControllerList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *shadow = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 10, self.view.frame.size.height)];
    shadow.image = [UIImage imageNamed:@"popshadow"];
    [self.view addSubview:shadow];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(panPopViewController:)];
    [panGestureRecognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
   [self.viewControllerList addObject:[self getScreenShot]];
    
   [super pushViewController:viewController animated:animated];
    
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.viewControllerList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

-(UIImage *)getScreenShot{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}
-(void)moveViewWithOffset:(float)x{

    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
}
- (void)panPopViewController:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.allowPanPop) return;
    
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouchPoint = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
        }
        
        self.backgroundView.hidden = NO;
        
        if (self.lastScreenShotView) [self.lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.viewControllerList lastObject];
        self.lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView addSubview:self.lastScreenShotView];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouchPoint.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithOffset:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithOffset:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithOffset:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithOffset:touchPoint.x - startTouchPoint.x];
    }
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
@end
