//
//  CommentTableViewCell.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/19.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame;

+(CGFloat)heightForCellWithDict:dict frame:(CGRect)frame;

@end
