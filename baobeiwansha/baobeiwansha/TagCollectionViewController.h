//
//  TagCollectionViewController.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/5.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshCustom.h"

@protocol TagCollectionViewDelegate

-(void)showHUD:(NSString *)text;
-(void)dismissHUD;

@end

@interface TagCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshDelegate>

@property (nonatomic,assign)NSInteger p;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong)NSDictionary *requestURL;

@property(nonatomic,retain)id<TagCollectionViewDelegate> delegate;

@end
