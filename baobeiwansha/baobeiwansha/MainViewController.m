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
#import "UserInfoSettingViewController.h"

#define HeadButtonSize 70

@interface MainViewController ()
{
    EMHint *_hint1;
    id _hilightView1;
    EMHint *_hint2;
    id _hilightView2;
    EMHint *_hint3;
    id _hilightView3;
    EMHint *_hint4;
    id _hilightView4;
    
}
@property (nonatomic,retain) UIView *center;
@property (nonatomic,strong) RecommendViewController *recommendViewController;

@property (nonatomic,strong) BubblesView *bubbleView;

@property (nonatomic,assign) BOOL isFirstLoad;

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic,assign) int reachability;

@property (nonatomic,retain) UIImageView *reachabilitySign;
@property (nonatomic,assign) BOOL isReachabilitySignShow;

@property (nonatomic,retain) UIImageView *waitingSign;



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
    [self initView];
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

-(void)profilePage{
    
    UserInfoViewController* UserInfoVC = [[UserInfoViewController alloc] init];
    UserInfoVC.delegate = self;
    [self customPushViewController:UserInfoVC];
    
}
-(void)updateRecommendViewControllerTitle{
    [self.recommendViewController updateUserInfo];
}

-(void)setBubbleTitles:(NSArray *)bubbleTitles{
    
    self.bubbleView = [[BubblesView alloc]initWithFrame:self.view.frame bubbleTitle:bubbleTitles];
    
    self.bubbleView.delegate = self;
    
    [self showHint];
    
    [self.view addSubview:self.bubbleView];
    
}
-(void)showHint{
    
    //第一次，显示遮罩层
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isOverlayShowed"]){
        
        _hint1 = [[EMHint alloc] init];
        [_hint1 setHintDelegate:self];
        _hilightView1 = self.bubbleView.girlButton;
        [_hint1 presentModalMessage:@"" where:self.navigationController.view];
        
        
    }
    
    
}
#pragma mark -EMHint deleage

-(NSArray*)hintStateViewsToHint:(id)hintState
{
    UIButton *hilightView;
    if(hintState == _hint1){
        hilightView = _hilightView1;
    }else if(hintState == _hint2){
        hilightView = _hilightView2;
    }else if(hintState == _hint3){
        hilightView = _hilightView3;
    }else if(hintState == _hint4){
        hilightView = _hilightView4;
    }
    return [[NSArray alloc] initWithObjects:hilightView, nil];
    
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    
    UILabel *l = [[UILabel alloc]init];
    l.backgroundColor = [UIColor clearColor];
    l.textColor =[UIColor whiteColor];
    l.font = [UIFont systemFontOfSize:14.0f];
    l.textAlignment = NSTextAlignmentCenter;
    
    if(hintState == _hint1){
        l.frame = CGRectMake(0, self.view.frame.size.height - 135, self.view.frame.size.width, 40);
        l.text= @"点击进入个人信息页";
    }else if(hintState == _hint2){
        l.frame = CGRectMake(0, 120, self.view.frame.size.width, 40);
        l.text= @"获取您宝宝的个性推荐";
    }else if(hintState == _hint3){
        l.frame = CGRectMake(0, 150, self.view.frame.size.width, 40);
        l.text= @"热门标签";
    }else if(hintState == _hint4){
        l.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 40);
        l.text= @"查看所有标签";
    }
    
    return l;
}
-(void)hintStateDidClose:(id)hintState{
    
    if(hintState == _hint1){
        self.center = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.height/2 - 100,100,100)];
        [self.view addSubview:self.center];
        _hint2 = [[EMHint alloc] init];
        [_hint2 setHintDelegate:self];
        _hilightView2 = self.center;
        [_hint2 presentModalMessage:@"" where:self.navigationController.view];
        
    }else if(hintState == _hint2){
        [self.center removeFromSuperview];
        _hint3 = [[EMHint alloc] init];
        [_hint3 setHintDelegate:self];
        _hilightView3 = self.bubbleView.bubbleButton1;
        [_hint3 presentModalMessage:@"" where:self.navigationController.view];
        
    }else if(hintState == _hint3){
        
        _hint4 = [[EMHint alloc] init];
        [_hint4 setHintDelegate:self];
        _hilightView4 = self.bubbleView.bubbleButton7;
        [_hint4 presentModalMessage:@"" where:self.navigationController.view];
        
    }else if(hintState == _hint4){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOverlayShowed"];
        
    }
    
    
    
    
    
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
    transition.duration = 0.3;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    __weak __block typeof(self) weakself = self;
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    
    self.internetReachability.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    
    self.internetReachability.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showReachabilitySign];
        });
    };
    
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.wifiReachability.reachableOnWWAN = NO;
    
    self.wifiReachability.reachableBlock = ^(Reachability * reachability)
    {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    //无wifi连接的时候，是不是要通知用户
    self.wifiReachability.unreachableBlock = ^(Reachability * reachability)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    [self.wifiReachability startNotifier];
    
    
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
    
    Reachability * reach = [note object];
    
    if (reach == self.internetReachability)
    {
        if([reach isReachable])
        {
            if(self.isReachabilitySignShow == YES){
                [self hideReachabilitySign];
            }
            
        }
        else
        {
            
            [self showReachabilitySign];
            
        }
    }
    
    
    
}

-(void)showReachabilitySign{
    
    if(!self.reachabilitySign){
        [self initReachabilitySign];
    }
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
