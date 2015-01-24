//
//  TagCollectionViewController.h
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/5.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) NSInteger index;

@end
