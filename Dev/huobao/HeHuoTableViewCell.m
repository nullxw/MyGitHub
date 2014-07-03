//
//  HeHuoTableViewCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeHuoTableViewCell.h"

@implementation HeHuoTableViewCell
@synthesize asyncImage;
@synthesize bgImage;
@synthesize lucencyView;
@synthesize halfCorner;
@synthesize halfCorner1;
@synthesize titleLabel;
@synthesize timeIcon;
@synthesize addressIcon;
@synthesize timeLabel;
@synthesize addressLabel;
@synthesize whiteLabel;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat scale = 2;
        
        CGFloat imageW = [[UIScreen mainScreen] bounds].size.width;
        CGFloat imageH = imageW/scale;
        CGFloat bgH = imageH + 80;
        
        
//        bgImage = [[UIView alloc] init];
//        bgImage.backgroundColor = [UIColor whiteColor];
//        bgImage.layer.cornerRadius = 3.0;
//        bgImage.layer.borderWidth = 1.0f;
//        bgImage.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f] CGColor];
//        bgImage.layer.masksToBounds = YES;
//        bgImage.frame = CGRectMake(10, 5, imageW, bgH);
//        [self addSubview:bgImage];
        
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        asyncImage.placeholderImage = [UIImage imageNamed:@"huobaolist_bg.png"];
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 0.0;
        asyncImage.layer.borderWidth = 0.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        
//        whiteLabel = [[UILabel alloc] init];
//        whiteLabel.frame = CGRectMake(0, asyncImage.frame.size.height - 1.5, asyncImage.frame.size.width, 10);
//        [whiteLabel setBackgroundColor:[UIColor whiteColor]];
//        [bgImage addSubview:whiteLabel];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(10, imageH + 10, 290.0f, 20.0f);
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.text = @"孙燕姿2014啊换交换机啊哈巡回演唱会";
        [self addSubview:titleLabel];
        
        timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeIcon.png"]];
        timeIcon.frame = CGRectMake(10, imageH + 35, 17, 17);
        [self addSubview:timeIcon];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.frame = CGRectMake(35.0, imageH + 33, 265.0f, 20.0f);
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        timeLabel.text = @"2014.05.31-2014.06.01";
        [self addSubview:timeLabel];
        
        addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressIcon.png"]];
        addressIcon.frame = CGRectMake(8, imageH + 55, 20, 20);
        [self addSubview:addressIcon];
        addressLabel = [[UILabel alloc] init];
        addressLabel.textColor = [UIColor blackColor];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.frame = CGRectMake(35.0, imageH + 55, 265.0f, 20.0f);
        addressLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        addressLabel.text = @"北京工人体育场";
        [self addSubview:addressLabel];
        
        
    }
    return  self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
