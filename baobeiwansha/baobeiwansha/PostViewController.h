//
//  PostViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextView.h"
#import "DTLazyImageView.h"
#import "DTCoreText.h"
#import "EGORefreshCustom.h"
#import "CommentCreateViewController.h"

@interface PostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,EGORefreshDelegate,CommentCreateDelegate>

-(void)initViewWithDict:(NSDictionary *)dict;
-(void)noDataAlert;
-(void)showHUD;
-(void)dismissHUD;

@end
