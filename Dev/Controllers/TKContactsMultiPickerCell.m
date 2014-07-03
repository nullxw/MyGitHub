//
//  TKContactsMultiPickerCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "TKContactsMultiPickerCell.h"

@implementation TKContactsMultiPickerCell
@synthesize nameLabel;
@synthesize button;
@synthesize asyncImage;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 10, 40.0f, 40.0f)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
        
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 5.0;
        asyncImage.layer.borderWidth = 0.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        nameLabel.frame = CGRectMake(70, 20.0, 200, 20.0);
        nameLabel.text = @"匿名";
        [self addSubview:nameLabel];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(30.0, 0.0, 28, 28)];
        [button setBackgroundImage:[UIImage imageNamed:@"uncheckBox.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateSelected];
        self.accessoryView = button;
        
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
