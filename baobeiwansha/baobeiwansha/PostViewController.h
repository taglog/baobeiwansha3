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
@protocol PostViewDelegate
//type = 1 收藏成功 type = 0 取消成功
-(void)updateCollectionCount:(NSIndexPath *)indexPath type:(NSInteger)type;

@end
@interface PostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,EGORefreshDelegate,CommentCreateDelegate>
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) id<PostViewDelegate>delegate;
-(void)initViewWithDict:(NSDictionary *)dict;
-(void)noDataAlert;
-(void)showHUD;
-(void)dismissHUD;

@end
