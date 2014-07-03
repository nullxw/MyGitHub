//
//  HeSubscribeCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeSubscribeCell.h"

@implementation HeSubscribeCell
@synthesize asyncImage;
@synthesize titleLabel;
@synthesize timeIcon;
@synthesize timeLabel;
@synthesize addressIcon;
@synthesize addressLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 17, 60.0, 60.0)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"音乐节.jpg"];
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        CGFloat iconX = 80.0;
        CGFloat iconY = 10.0f;
        CGFloat iconW = 20.0f;
        CGFloat iconH = 20.0f;
        CGFloat labelW = 200.0f;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.text = @"2014秦皇岛6789海洋音乐节";
        titleLabel.frame = CGRectMake(iconX, iconY, labelW, iconH);
        [self addSubview:titleLabel];
        
        timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeIcon.png"]];
        timeIcon.frame = CGRectMake(iconX, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, iconW, iconH);
        [self addSubview:timeIcon];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"2014.06.09 8:00";
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.frame = CGRectMake(iconX + timeIcon.frame.size.width + 5, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, labelW, iconH);
        [self addSubview:timeLabel];
        
        addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressIcon.png"]];
        addressIcon.frame = CGRectMake(iconX - 2, timeIcon.frame.origin.y + timeIcon.frame.size.height + 5, iconW + 3, iconH + 3);
        [self addSubview:addressIcon];
        
        
        addressLabel = [[UILabel alloc] init];
        addressLabel.text = @"广东广州体育东路";
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.frame = CGRectMake(iconX + addressIcon.frame.size.width + 5, timeLabel.frame.origin.y + timeLabel.frame.size.height + 5, labelW, iconH);
        [self addSubview:addressLabel];
        
    }
    return self;
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
