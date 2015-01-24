//
//  CommentTableViewCell.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/19.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell()
{
    CGRect _frame;
    CGFloat paddingHor;
    CGFloat paddingVer;
}
@property(nonatomic,weak)NSDictionary *dict;

@property(nonatomic,weak)UIImageView *userImage;

@property(nonatomic,weak)UILabel *userName;

@property(nonatomic,weak)UILabel *userComment;

@property(nonatomic,weak)UILabel *commentTime;


@end

@implementation CommentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //用户名
        UILabel *userName = [[UILabel alloc] init];
        [self addSubview:userName];
        self.userName = userName;
        
        //评论时间
        UILabel *commentTime = [[UILabel alloc] init];
        [self addSubview:commentTime];
        self.commentTime = commentTime;
        
        //用户评论
        UILabel *userComment = [[UILabel alloc] init];
        [self addSubview:userComment];
        self.userComment = userComment;
        
        paddingHor = 15.0f;
        paddingVer = 10.0f;
    }
    
    return self;
}
//给cell中得key赋值
-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    _dict = dict;
    _frame = frame;
    
    self.userName.text = [dict objectForKey:@"comment_author"];
    
    self.commentTime.text = [dict objectForKey:@"comment_date"];

    self.userComment.text = [dict objectForKey:@"comment_content"];

    
    [self setNeedsLayout];
    
}
//计算cell的高度
+(CGFloat)heightForCellWithDict:dict frame:(CGRect)frame{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};
    CGRect textRect = [[dict objectForKey:@"comment_content"]boundingRectWithSize:CGSizeMake(frame.size.width - 30.0f, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attributes
                                                          context:nil];
    CGFloat heightForCell = 90 + textRect.size.height ;
    
    return heightForCell;
    
}
//布局layout
-(void)layoutSubviews{
    [super layoutSubviews];
    //用户昵称
    self.userName.frame = CGRectMake(paddingHor, paddingVer,280,20.0f);
    self.userName.font = [UIFont systemFontOfSize:14.0f];
    self.userName.textColor = [UIColor colorWithRed:254.0f/255.f green:70.0f/255.f blue:116.0f/255.f alpha:1.0];
    
    //评论内容
    CGFloat heightForUserComment = [[self class] heightForCellWithDict:_dict frame:_frame];
    self.userComment.frame = CGRectMake(15.0f, 35.0f, _frame.size.width - 2 *paddingHor , heightForUserComment - 80.0f);
    self.userComment.numberOfLines = 0;
    self.userComment.font = [UIFont systemFontOfSize:15.0f];
    
    
    
    //评论时间
    self.commentTime.frame = CGRectMake(paddingHor, heightForUserComment - 38 , 280.0f, 20.0f);
    self.commentTime.font = [UIFont systemFontOfSize:12.0f];
    self.commentTime.textColor = [UIColor colorWithRed:119.0f/255.f green:119.0f/255.f blue:119.0f/255.f alpha:1.0];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
