//
//  TagCollectionViewCell.m
//  baobaowansha4
//
//  Created by 刘昕 on 15/1/6.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TagCollectionViewCell()
{
    CGRect aframe;

}
@property (nonatomic,retain) UIView *imageView;
@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) NSDictionary *dict;
@end


@implementation TagCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.imageView = [[UIView alloc]init];
    [self.contentView addSubview:self.imageView];
    
    self.iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconView];
    
    self.label = [[UILabel alloc]init];
    [self.contentView addSubview:self.label];
    
    return self;
}




-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.dict = dict;
    aframe = frame;
    
    [self setNeedsLayout];
}

-(UIColor *)getColor{
    
    static int index = 0;
    
    UIColor *lightBlueColor = [UIColor colorWithRed:33.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIColor *purpleColor = [UIColor colorWithRed:191.0/255.0 green:104.0/255.0 blue:174.0/255.0 alpha:1.0];
    UIColor *roseColor = [UIColor colorWithRed:248.0/255.0 green:55.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *yellowColor = [UIColor colorWithRed:249.0/255.0 green:197.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *blueColor = [UIColor colorWithRed:38.0/255.0 green:171.0/255.0 blue:227.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:132.0/255.0 green:209.0/255.0 blue:53.0/255.0 alpha:1.0];
    UIColor *darkBlueColor = [UIColor colorWithRed:138.0/255.0 green:151.0/255.0 blue:210.0/255.0 alpha:1.0];
    UIColor *lightBlueColor2 = [UIColor colorWithRed:33.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIColor *deepOrangeColor = [UIColor colorWithRed:255.0/255.0 green:87.0/255.0 blue:34.0/255.0 alpha:1.0];
    UIColor *orangeColor = [UIColor colorWithRed:255.0/255.0 green:130.0/255.0 blue:90.0/255.0 alpha:1.0];
    UIColor *greenColor2 = [UIColor colorWithRed:133.0/255.0 green:209.0/255.0 blue:49.0/255.0 alpha:1.0];
    UIColor *purpleColor2 = [UIColor colorWithRed:193.0/255.0 green:107.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    NSArray *colorBox = [NSArray arrayWithObjects:lightBlueColor,purpleColor,roseColor,yellowColor,blueColor,greenColor,darkBlueColor,lightBlueColor2,deepOrangeColor,orangeColor,greenColor2,purpleColor2,nil];
    
    UIColor *color = colorBox[index%12];
    
    index++;
    
    return color;
}

-(void)layoutSubviews{
    
    
    self.imageView.frame = CGRectMake((aframe.size.width/3 - 60)/2, 13, 60, 60);
    self.imageView.backgroundColor = [self getColor];
    self.imageView.layer.cornerRadius = 30;
    self.imageView.layer.masksToBounds = YES;
    
    self.iconView.frame = CGRectMake((aframe.size.width/3 - 40)/2, 23, 40, 40);
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    
    if([self.dict valueForKey:@"tag_imgurl"]){
        NSString *imgUrlString = [NSString stringWithFormat:@"http://61.174.9.214/www/imgs/tagicon/%@.png",[self.dict valueForKey:@"tag_imgurl"]];
        NSURL *imgUrl = [NSURL URLWithString:[imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.iconView  setImageWithURL:imgUrl placeholderImage:nil];
        
    }



    self.label.frame = CGRectMake(0,80, aframe.size.width/3,20);
    self.label.text = [self.dict valueForKey:@"name"];
    self.label.textColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];

    self.label.font = [UIFont systemFontOfSize:13.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0.8f);
    
    bottomBorder.backgroundColor = [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] CGColor];
    
    CALayer *rightBorder = [CALayer layer];
    
    rightBorder.frame = CGRectMake(CGRectGetWidth(self.frame),0.0f, 0.8f, CGRectGetHeight(self.frame));
    
    rightBorder.backgroundColor = [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] CGColor];
    
    [self.layer addSublayer:rightBorder];
    [self.layer addSublayer:bottomBorder];
    
}


@end
