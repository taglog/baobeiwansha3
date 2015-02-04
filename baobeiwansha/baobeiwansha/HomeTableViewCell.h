//
//  HomeTableViewCell.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isViewed;
-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame;

@end
