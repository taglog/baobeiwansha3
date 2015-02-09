//
//  HomeTableViewCell.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
@interface HomeTableViewCell()

//postID
@property (nonatomic,assign) NSInteger ID;

//缩略图
@property (nonatomic,strong) UIImageView *image;

//标题
@property (nonatomic,strong) UILabel *title;

//摘要
@property (nonatomic,strong) UILabel *introduction;

//适合年龄
@property (nonatomic,strong) UILabel *age;

//收藏人数
@property (nonatomic,strong) UILabel *collectionNumber;

//评论人数
@property (nonatomic,strong) UILabel *commentNumber;

//传入的frame
@property (nonatomic,assign)CGRect aFrame;

@property (nonatomic,retain)NSDictionary *dict;
@end

@implementation HomeTableViewCell

//初始化Cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        //添加缩略图
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.image = image;
        
        //添加标题
        UILabel *title = [[UILabel alloc] init];
        [self.contentView addSubview:title];
        self.title = title;
        
        //添加摘要
        UILabel *introduction = [[UILabel alloc] init];
        [self.contentView addSubview:introduction];
        self.introduction = introduction;
        
        //添加适合年龄
        UILabel *age = [[UILabel alloc] init];
        [self.contentView addSubview:age];
        self.age = age;
        
        //添加收藏人数
        UILabel *collectionNumber = [[UILabel alloc] init];
        [self.contentView addSubview:collectionNumber];
        self.collectionNumber = collectionNumber;
        
        //添加评论人数
        UILabel *commentNumber = [[UILabel alloc] init];
        [self.contentView addSubview:commentNumber];
        self.commentNumber = commentNumber;
        
    }
    return self;
}

//给Cell中的key赋值
-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.dict = dict;
    
    self.aFrame = frame;
    
    if([dict valueForKey:@"ID"] != (id)[NSNull null]){
        self.ID = [[dict valueForKey:@"ID"] integerValue];
    }

    
    NSString *imagePathOnServer = @"http://blog.yhb360.com/wp-content/uploads/";
    NSString *imageGetFromServer = [dict valueForKey:@"post_cover"];
    
    //没有设置特色图像的话会报错，所以需要检测是否为空
    if(imageGetFromServer != (id)[NSNull null]){
        NSString *imageString = [imagePathOnServer stringByAppendingString:imageGetFromServer];
        NSURL *imageUrl = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.image setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }else{
        //没有特色图像的时候，怎么办
        [self.image setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }
    if([dict objectForKey:@"post_title"] != (id)[NSNull null]){
        self.title.text = [dict objectForKey:@"post_title"];
    }
    if([dict objectForKey:@"post_excerpt"] != (id)[NSNull null]){
        self.introduction.text = [dict objectForKey:@"post_excerpt"];
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.introduction.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.introduction.text length])];
        [self.introduction setAttributedText:attributedString1];
    }
    
    
    
    //把月份装换成x岁x月的形式
    NSString *beginAge;
    NSString *endAge;
    NSString *showAge;
    if([dict valueForKey:@"fit_month_begin_1"] != (id)[NSNull null]){
        if([[dict valueForKey:@"fit_month_begin_1"]integerValue]>24){
            beginAge = [NSString stringWithFormat:@"%ld岁%ld个月-",[[dict valueForKey:@"fit_month_begin_1"]integerValue]/12,[[dict valueForKey:@"fit_month_begin_1"]integerValue]%12];
            if([[dict valueForKey:@"fit_month_begin_1"]integerValue]%12 == 0){
                beginAge = [NSString stringWithFormat:@"%ld岁",[[dict valueForKey:@"fit_month_begin_1"]integerValue]/12];
            }
        }else{
            beginAge = [NSString stringWithFormat:@"%ld个月-",[[dict valueForKey:@"fit_month_begin_1"]integerValue]];
        }
    }
    if([dict valueForKey:@"fit_month_end_1"] != (id)[NSNull null]){
        
        if([[dict valueForKey:@"fit_month_end_1"]integerValue]>24){
            endAge = [NSString stringWithFormat:@"%ld岁%ld个月",[[dict valueForKey:@"fit_month_end_1"]integerValue]/12,[[dict valueForKey:@"fit_month_end_1"]integerValue]%12];
            if([[dict valueForKey:@"fit_month_end_1"]integerValue]%12 == 0){
                endAge = [NSString stringWithFormat:@"%ld岁",[[dict valueForKey:@"fit_month_end_1"]integerValue]/12];
            }
        }else{
            endAge = [NSString stringWithFormat:@"%ld个月",[[dict valueForKey:@"fit_month_end_1"]integerValue]];
        }
    }
    showAge = [beginAge stringByAppendingString:endAge];
    
    self.age.text = [@"适合:" stringByAppendingString:showAge];
    if([dict objectForKey:@"collection_count"]){
        self.collectionNumber.text = [NSString stringWithFormat:@"收藏 %@",[dict objectForKey:@"collection_count"]];
    }
    
    
    [self setNeedsLayout];
    
}

-(void)updateCollectionCount:(NSInteger)collectionNumber{
    
    self.collectionNumber.text = [NSString stringWithFormat:@"收藏 %ld", (long)collectionNumber];
    
    [self setNeedsLayout];
    
}
//设置Cell子控件的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //padding
    CGFloat paddingHor = 15.0f;
    CGFloat paddingVer = 10.0f;
    
    //缩略图的frame
    self.image.frame = CGRectMake(paddingHor, paddingVer, 80.0f, 80.0f);
    self.image.clipsToBounds  = YES;
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //标题的frame
    self.title.frame = CGRectMake(107.0f, paddingVer, self.aFrame.size.width - 100.0, 20.0);
    
    
    self.title.textColor = [UIColor colorWithRed:17.0f/255.0f green:17.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    
    self.title.font = [UIFont systemFontOfSize:17.0f];
    
    
    //摘要的frame
    self.introduction.frame = CGRectMake(107.0, 27.0,self.aFrame.size.width - 120.0, 50.0);
    
    self.introduction.font = [UIFont systemFontOfSize:13.0];
    self.introduction.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    self.introduction.numberOfLines = 2;
    [self.introduction setLineBreakMode:NSLineBreakByWordWrapping];
    //年龄的frame
    self.age.frame = CGRectMake(107.0, 73.0, self.aFrame.size.width - 100, 20);
    
    self.age.font = [UIFont systemFontOfSize:12.0];
    self.age.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    
    //收藏数量的frame
    self.collectionNumber.frame = CGRectMake(self.aFrame.size.width - 55, 73.0, 60.0, 20.0);
    
    self.collectionNumber.font = [UIFont systemFontOfSize:12.0];
    self.collectionNumber.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    
    //评论数量的frame
    //    self.commentNumber.frame = CGRectMake(self.aFrame.size.width - 55, 73.0, 60.0, 20.0);
    //    self.commentNumber.font  = [UIFont systemFontOfSize:12.0];
    //    self.commentNumber.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
    
}

@end
