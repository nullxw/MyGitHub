//
//  ContactUsCell.m
//  huobao
//
//  Created by HeDongMing on 14-6-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "ContactUsCell.h"

@implementation ContactUsCell
@synthesize asyncImage;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize messageIcon;
@synthesize callButton;
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat imageX = 10.0f;
        CGFloat imageY = 10.0f;
        CGFloat imageW = 60.0f;
        CGFloat imageH = 60.0f;

        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 0.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        nameLabel.text = @"周美慧";
        nameLabel.frame = CGRectMake(imageX + imageW + 10, imageY + 5, 150, 20.0f);
        [self addSubview:nameLabel];
        
        phoneLabel = [[UILabel alloc] init];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.textColor = [UIColor grayColor];
        phoneLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        phoneLabel.text = @"1358989456";
        phoneLabel.frame = CGRectMake(imageX + imageW + 10, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 150, 20.0f);
        [self addSubview:phoneLabel];
        
        CGFloat buttonX = 230.0f;
        CGFloat buttonW = 30.0;
        CGFloat buttonY = 25.0f;
        CGFloat buttonH = 30.0;
        
        messageIcon = [[UIButton alloc] init];
        [messageIcon setBackgroundImage:[UIImage imageNamed:@"contact_messageIcon"] forState:UIControlStateNormal];
   
        messageIcon.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [messageIcon addTarget:self action:@selector(messagebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:messageIcon];
        
        callButton = [[UIButton alloc] init];
        [callButton setBackgroundImage:[UIImage imageNamed:@"contact_callIcon"] forState:UIControlStateNormal];
  
        callButton.frame = CGRectMake(messageIcon.frame.origin.x + messageIcon.frame.size.width + 20.0, buttonY, buttonW, buttonH);
        [callButton addTarget:self action:@selector(callbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:callButton];
        
    }
    return self;
}

-(void)messagebuttonClick:(id)sender
{
    [delegate contactWithString:phoneLabel.text type:1];
}

-(void)callbuttonClick:(id)sender
{
    [delegate contactWithString:phoneLabel.text type:2];
}

@end
