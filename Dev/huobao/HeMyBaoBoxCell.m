//
//  HeMyBaoBoxCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeMyBaoBoxCell.h"

@implementation HeMyBaoBoxCell
@synthesize asyncImage;
@synthesize titleLabel;
@synthesize timeIcon;
@synthesize timeLabel;
@synthesize addressIcon;
@synthesize addressLabel;
@synthesize circleIcon;
@synthesize numberLabel;
@synthesize backgrdView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat scale = 600.0/200.0;
        CGFloat bgH = ([[UIScreen mainScreen] bounds].size.width - 20)/scale;
        backgrdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"单票.png"]];
        backgrdView.highlightedImage = [UIImage imageNamed:@"单票hightlighted.png"];
        backgrdView.frame = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width - 20, bgH);
        backgrdView.backgroundColor = [UIColor clearColor];
        backgrdView.userInteractionEnabled = YES;
        [self addSubview:backgrdView];
        
        
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 20, bgH - 40, bgH - 40)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [backgrdView addSubview:asyncImage];
     
        CGFloat iconX = bgH - 20;
        CGFloat iconY = 15.0f;
        CGFloat iconW = 20.0f;
        CGFloat iconH = 20.0f;
        CGFloat labelW = 160.0f;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.text = @"2014秦皇岛6789海洋音乐节";
        titleLabel.frame = CGRectMake(iconX, iconY, labelW, iconH);
        [backgrdView addSubview:titleLabel];
        
        timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeIcon.png"]];
        timeIcon.frame = CGRectMake(iconX, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, iconW, iconH);
        [backgrdView addSubview:timeIcon];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"2014.06.09 8:00";
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.frame = CGRectMake(iconX + timeIcon.frame.size.width + 5, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, labelW, iconH);
        [backgrdView addSubview:timeLabel];
        
        addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressIcon.png"]];
        addressIcon.frame = CGRectMake(iconX - 2, timeIcon.frame.origin.y + timeIcon.frame.size.height + 5, iconW + 3, iconH + 3);
        [backgrdView addSubview:addressIcon];
        
        addressLabel = [[UILabel alloc] init];
        addressLabel.text = @"广东广州体育东路";
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.frame = CGRectMake(iconX + addressIcon.frame.size.width + 5, timeLabel.frame.origin.y + timeLabel.frame.size.height + 5, labelW, iconH);
        [backgrdView addSubview:addressLabel];
        
        circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleIcon.png"]];
        circleIcon.frame = CGRectMake(backgrdView.frame.size.width - 40, (bgH - 30)/2, 30, 30);
        
        numberLabel = [[UILabel alloc] init];
        numberLabel.backgroundColor = [UIColor clearColor];
        [numberLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
        numberLabel.text = @"12";
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.frame = CGRectMake(-1, 0, 30, 30);
        [circleIcon addSubview:numberLabel];
        [backgrdView addSubview:circleIcon];
        
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
