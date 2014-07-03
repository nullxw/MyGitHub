//
//  HeJiFenHistoryCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeJiFenHistoryCell.h"

@implementation HeJiFenHistoryCell
@synthesize titleLabel;
@synthesize timeLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier   ];
    if (self) {
        CGFloat labelX = 10.0f;
        CGFloat labelW = 230.0f;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.numberOfLines = 2;
        timeLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
        
        titleLabel.text = @"参加2014海洋公wwwwww开演唱eeeeeeew会3积分";
        titleLabel.frame = CGRectMake(labelX, 10, labelW, 35);
        [self addSubview:titleLabel];
        
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        timeLabel.text = @"2014.08.09";
        timeLabel.frame = CGRectMake(245.0f, 15.0f, 70.0, 20.0);
        [self addSubview:timeLabel];
        
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
