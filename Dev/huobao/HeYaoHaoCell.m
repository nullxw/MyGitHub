//
//  HeYaoHaoCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeYaoHaoCell.h"

@implementation HeYaoHaoCell
@synthesize asyncImage;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize statueLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
        
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        CGFloat labelX = 80.0f;
        CGFloat labelW = 170.0f;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.numberOfLines = 2;
        titleLabel.text = @"2014海洋公开演唱会ahjhdajhdja178478741941";
        titleLabel.frame = CGRectMake(labelX, 10, labelW, 35);
        [self addSubview:titleLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        timeLabel.text = @"2014.08.09 8:09";
        timeLabel.frame = CGRectMake(labelX, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, labelW, 20.0);
        [self addSubview:timeLabel];
        
        
        statueLabel = [[UILabel alloc] init];
        statueLabel.backgroundColor = [UIColor clearColor];
        statueLabel.textColor = [UIColor greenColor];
        statueLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        statueLabel.text = @"成功";
        statueLabel.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, 30.0, 50, 20.0);
        statueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:statueLabel];
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
