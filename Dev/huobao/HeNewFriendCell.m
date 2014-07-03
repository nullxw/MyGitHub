//
//  HeNewFriendCell.m
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeNewFriendCell.h"
#import "Dao.h"
#import "Dao+syncFriendCategory.h"

@implementation HeNewFriendCell
@synthesize titleLabel;
@synthesize asyncImage;
@synthesize signLabel;
@synthesize checkButton;
@synthesize fuid;
@synthesize uid;
@synthesize agreeDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self ) {
        asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
        asyncImage.imageURL = nil;
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [self addSubview:asyncImage];
        
        CGFloat labelX = 70.0f;
        CGFloat labelW = 150.0f;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        titleLabel.numberOfLines = 1;
        titleLabel.text = @"小伙伴23号";
        titleLabel.frame = CGRectMake(labelX, 15, labelW, 20);
        [self addSubview:titleLabel];
        
        signLabel = [[UILabel alloc] init];
        signLabel.backgroundColor = [UIColor clearColor];
        signLabel.textColor = [UIColor grayColor];
        signLabel.numberOfLines = 2;
        signLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        signLabel.text = @"我是小伙伴2014.08.09 8:09";
        signLabel.frame = CGRectMake(labelX, 30, labelW, 40.0);
        [self addSubview:signLabel];
        
        checkButton = [[UIButton alloc] init];
        [checkButton setTitle:@"添加" forState:UIControlStateNormal];
        checkButton.frame = CGRectMake(250.0, 25.0, 60.0, 30.0);
        [checkButton successStyle];
        [checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkButton];
        
        HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
        fuid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
        
    }
    return self;
}

-(void)checkButtonClick:(id)sender
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"fuid",fuid,@"uid", nil];
    Dao *shareDao = [Dao sharedDao];
    NSDictionary *dict = [shareDao agreeRequestAddFriend:dic];
    [agreeDelegate agreeWithDic:dict];
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
