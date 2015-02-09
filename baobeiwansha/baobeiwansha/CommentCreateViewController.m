//
//  CommentCreateViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/2.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CommentCreateViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface CommentCreateViewController ()

@property(nonatomic,strong)UITextView *commentTextView;
@property(nonatomic,strong)UITextView *commentTextField;
//该post的ID
@property(nonatomic,assign)NSInteger postID;
//post到后台的字典
@property(nonatomic,strong)NSDictionary *commentPostParams;

@property (nonatomic,retain)AppDelegate *appDelegate;
@property (nonatomic,strong)JGProgressHUD *HUD;
@end

@implementation CommentCreateViewController

-(id)initWithID:(NSInteger)postID{
    self = [super init];
    
    self.postID = postID;
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    //提交按钮
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"check.png"] style:UIBarButtonItemStylePlain target:self action:@selector(commentSubmit)];
    submitButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    //自定义leftBarButtonItem以取代返回按钮
    UIBarButtonItem *backButtonCustom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    backButtonCustom.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = backButtonCustom;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1.0f];
    
    self.title = @"写评论";
    
    UIView *whiteSpace = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
    whiteSpace.backgroundColor =[UIColor whiteColor];
    
    if(_commentTextField == nil){
        _commentTextField = [[UITextView alloc]initWithFrame:CGRectMake(15.0f, 15.0f, self.view.frame.size.width - 30.0f, 40.0f)];
        _commentTextField.tag = 1;
        _commentTextField.text = @"请输入您评论的昵称";
        _commentTextField.textColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1.0f];
        _commentTextField.delegate = self;
        _commentTextField.backgroundColor = [UIColor whiteColor];
        _commentTextField.scrollEnabled = NO;
        
        _commentTextField.returnKeyType = UIReturnKeyDefault;
        
        _commentTextField.keyboardType = UIKeyboardTypeDefault;
        _commentTextField.font = [UIFont systemFontOfSize:14.0f];
        //_commentTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _commentTextField.layer.borderWidth = 0.5f;
        _commentTextField.layer.borderColor = [[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]CGColor];
    }
    
    if(_commentTextView == nil){
        _commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(15.0f, 60.0f, self.view.frame.size.width - 30.0f , 250.0f)];
        _commentTextView.tag = 2;
        _commentTextView.delegate = self;
        
        _commentTextView.backgroundColor = [UIColor whiteColor];
        
        _commentTextView.returnKeyType = UIReturnKeyDefault;
        
        _commentTextView.keyboardType = UIKeyboardTypeDefault;
        _commentTextView.font = [UIFont systemFontOfSize:14.0f];
        
        _commentTextView.text = @"请在此输入您的评论";
        
        _commentTextView.textColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1.0f];
        
        _commentTextView.scrollEnabled = YES;
        
        _commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _commentTextView.layer.borderWidth = 0.5f;
        
        _commentTextView.layer.borderColor = [[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]CGColor];
    }
    
    
    [self.view addSubview:_commentTextField];
    [self.view addSubview:_commentTextView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 1){
        if ([textView.text isEqualToString:@"请输入您评论的昵称"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }else{
        if ([textView.text isEqualToString:@"请在此输入您的评论"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    [textView becomeFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)commentSubmit{
    
    
    
    NSString *text = _commentTextView.text;
    NSString *userNickName = _commentTextField.text;
    
    //如果用户输入不为空
    if([userNickName isEqualToString:@""] || [userNickName isEqualToString:@"请输入您评论的昵称"]){
        //用户没有输入的时候，该做些什么
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"请输入您评论的昵称";
        [self.HUD showInView:self.view];
        [self.HUD dismissAfterDelay:1.0];
        return;
    }
    if([text isEqualToString:@""] || [text isEqualToString:@"请在此输入您的评论"]){
            //用户没有输入的时候，该做些什么
            self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            self.HUD.textLabel.text = @"请输入您的评论";
            [self.HUD showInView:self.view];
            [self.HUD dismissAfterDelay:1.0];
        return;
    }
    
        
        //初始化HUD
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"保存中...";
        [self.HUD showInView:self.view];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.commentPostParams = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_postID],@"comment_post_ID", text,@"comment_content",userNickName,@"comment_author",self.appDelegate.generatedUserID,@"userIdStr",nil];
        
        NSString *commentCreateRouter = @"/comment/create";
        NSString *commentCreateRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentCreateRouter];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        [manager POST:commentCreateRequestUrl  parameters:self.commentPostParams success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSInteger status = [[responseObject valueForKey:@"status"]integerValue];
            if(status == 1){
                
                NSDictionary *commentToPostViewController = [NSDictionary dictionaryWithObjectsAndKeys:userNickName,@"comment_author",text,@"comment_content",[responseObject valueForKey:@"comment_date"],@"comment_date",[responseObject valueForKey:@"comment_id"],@"comment_id", nil];
                //输入完成，应该跳回到上一页，同时把上一页的tableView刷新
                [self.delegate commentCreateSuccess:commentToPostViewController];
                [self.HUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                //否则的话，弹出一个指示层
                self.HUD.textLabel.text = @"保存失败";
                [self.HUD showInView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.HUD dismiss];
                });
                
                
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.HUD.textLabel.text = @"网络请求失败";
            [self.HUD showInView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.HUD dismiss];
            });
            NSLog(@"%@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    
    
}

-(void)addUserName:(NSArray *)userName{
    
    if([_commentTextField.text isEqualToString:@""] || [_commentTextField.text isEqualToString:@"请输入您评论的昵称"]){
        
        if([userName valueForKey:@"userNickName"] !=(id)[NSNull null]){
            NSString *userNickName = [userName valueForKey:@"userNickName"];
            //如果用户存得宝宝昵称不为空字符，就读出来显示
            if(![[userName valueForKey:@"userNickName"]isEqualToString:@""]&&![[userName valueForKey:@"userNickName"]isEqualToString:@" "]){
                _commentTextField.text = userNickName;
                _commentTextField.textColor = [UIColor blackColor];
            }
        }
           }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
