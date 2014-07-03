//
//  HeGiveTicketCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeGiveTicketCell.h"

@implementation HeGiveTicketCell
@synthesize asyncImage;
@synthesize nameLabel;
@synthesize releaseButton;
@synthesize numberLabel;
@synthesize addButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat imageW = 50.0;
        CGFloat imageY = 10.0f;
        CGFloat imageX = 10.0f;
        
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
        asyncImage.imageURL = nil;
        
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.frame = CGRectMake(imageX + imageW + 10, 25.0, 200, 20.0);
        nameLabel.text = @"小伙伴23号";
        [self addSubview:nameLabel];
        
        releaseButton = [[UIButton alloc] init];
        [releaseButton setImage:[UIImage imageNamed:@"releaseEnable.png"] forState:UIControlStateNormal];
        releaseButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 115.0, 22.5, 25, 25);
        [releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:releaseButton];
        
        numberLabel = [[UILabel alloc] init];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor redColor];
        numberLabel.font = [UIFont fontWithName:@"Helvetica" size:16.5f];
        numberLabel.text = @"X 0";
        numberLabel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 90.0, 20.0, 50, 30);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numberLabel];
        
        addButton = [[UIButton alloc] init];
        [addButton setImage:[UIImage imageNamed:@"addEnable.png"] forState:UIControlStateNormal];
        addButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 40.0, 22.5, 25, 25);
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
    }
    
    return self;
    
}

-(void)addButtonClick:(UIButton *)sender
{
    int number = 0;
    NSString *numStr = [self.numberLabel.text substringFromIndex:2];
    number = [numStr intValue];
    number++;
    numberLabel.text = [NSString stringWithFormat:@"X %d",number];
}

-(void)releaseButtonClick:(UIButton *)sender
{
    int number = 0;
    NSString *numStr = [self.numberLabel.text substringFromIndex:2];
    number = [numStr intValue];
    if (number == 0) {
        return;
    }
    else{
        number--;
        numberLabel.text = [NSString stringWithFormat:@"X %d",number];
    }
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
