//
//  MainViewController.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "MainViewController.h"
#import "RecommendViewController.h"
#import "TagPostTableViewController.h"
#import "TagViewController.h"
#import "OBShapedButton.h"
#import "Reachability.h"
#import "UserInfoViewController.h"
#define HeadButtonSize 70

@interface MainViewController ()

@property (nonatomic,strong) RecommendViewController *recommendViewController;

@property (nonatomic,strong) BubblesView *bubbleView;

@property (nonatomic,assign) BOOL isFirstLoad;

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic,assign) int reachability;

@property (nonatomic,retain) UIImageView *reachabilitySign;
@property (nonatomic,assign) BOOL isReachabilitySignShow;


@end

@implementation MainViewController
-(id)init{
    self = [super init];
    
    self.isFirstLoad = YES;
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initReachability];
    [self initBubbles];
    [self initView];
    [self initUserInfo];

    
    self.recommendViewController = [[RecommendViewController alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if(!self.isFirstLoad){
        
        [self.bubbleView resumeAnimation];
        
    }else{
        [self.bubbleView performInitializationAnimation];
        [self.bubbleView performSelector:@selector(performShakeAnimation) withObject:nil afterDelay:2.0];
        
        self.isFirstLoad = NO;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
-(void)initUserInfo{
    
    UIButton *profileButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 24, 24)];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(userProfile) forControlEvents:UIControlEventTouchUpInside];
    profileButton.tintColor = [UIColor redColor];
    
    [self.view addSubview:profileButton];
    
}
-(void)userProfile{
    
    UserInfoViewController* UserInfoVC = [[UserInfoViewController alloc] init];
    [self customPushViewController:UserInfoVC];

}
-(void)initBubbles{
    
    self.bubbleView = [[BubblesView alloc]initWithFrame:self.view.frame];
    self.bubbleView.delegate = self;
    
    [self.view addSubview:self.bubbleView];
    
}

-(void)initView{
    
    //设置背景图片3
    UIImage *backgroundImage = [UIImage imageNamed:@"mainbg"];
    self.view.layer.contents = (id) backgroundImage.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
}

//点击中心大圆
-(void)getRecommendedContent{
    
    [self customPushViewController:self.recommendViewController];
    
}

//点击小bubble
-(void)bubbleClicked:(NSString *)tag{
    
    TagPostTableViewController *tagPostTableViewController = [[TagPostTableViewController alloc]init];
    tagPostTableViewController.requestURL = @{@"requestRouter":@"post/discover"};
    tagPostTableViewController.tag = tag;
    [self customPushViewController:tagPostTableViewController];
    
    
    
}

//点击更多
-(void)moreBubbleClicked{
    
    TagViewController *tagViewController = [[TagViewController alloc]init];
    [self customPushViewController:tagViewController];
    
}

//自定义push动画，否则会有导航栏的问题
//window的背景需要设置成与mainViewController背景一样，否则会出现闪一下的效果
-(void)customPushViewController:(UIViewController *)viewController{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.bubbleView performSelector:@selector(pauseAnimation) withObject:nil afterDelay:0.3f];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

-(void)resumeAnimation{
    [self.bubbleView performShakeAnimation];
    
}

-(void)initReachability{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    
    [self initReachabilityTest];
    
}

//进入viewcontroller进行第一次测试
-(void)initReachabilityTest{
    
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    NetworkStatus wifiStatus = [self.wifiReachability currentReachabilityStatus];
    
    //not reachable
    if(netStatus == NotReachable && wifiStatus == NotReachable){
        self.reachability = 0;
        [self initReachabilitySign];
        [self showReachabilitySign];
        
    }else if(netStatus != NotReachable && wifiStatus == NotReachable){
        //celluar
        self.reachability = 1;
    }else if(netStatus != NotReachable && wifiStatus == NotReachable){
        //wifi
        self.reachability = 2;
    }
    
   
}


-(void)initReachabilitySign{
    
    if(!self.reachabilitySign){
        self.reachabilitySign = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 20, 180, 80)];
        self.reachabilitySign.image = [UIImage imageNamed:@"reachability"];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, 180, 20)];
        label.text = @"没有网络连接哦~";
        label.textColor = [UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        [self.reachabilitySign addSubview:label];
        [self.view addSubview:self.reachabilitySign];
    }
    
}

-(void)reachabilityChanged:(NSNotification *)note{
    
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        if(netStatus == NotReachable){
            if(!self.reachabilitySign){
                [self initReachabilitySign];
            }
            [self showReachabilitySign];
        }else{
            
            if(self.isReachabilitySignShow == YES){
                [self hideReachabilitySign];
            }
        }
    }
    
    if (reachability == self.wifiReachability)
    {
        NetworkStatus wifiStatus = [reachability currentReachabilityStatus];
        if(wifiStatus == NotReachable){
            if(!self.reachabilitySign){
                [self initReachabilitySign];
            }
            [self showReachabilitySign];
        }else{
            if(self.isReachabilitySignShow == YES){
                [self hideReachabilitySign];
            }
        }
    }
    

    
}

-(void)showReachabilitySign{
    
    [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.reachabilitySign.frame = CGRectMake(self.view.frame.size.width - 200, 20, 180, 80);
    } completion:nil];
    self.isReachabilitySignShow = YES;
    
}

-(void)hideReachabilitySign{
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.reachabilitySign.frame = CGRectMake(self.view.frame.size.width, 20, 180, 80);
    } completion:nil];
    self.isReachabilitySignShow = NO;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
