//
//  HeNewFriendCell.h
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"
#import "UIButton+Bootstrap.h"

@protocol agreeProtocol <NSObject>

-(void)agreeWithDic:(NSDictionary *)dic;

@end

@interface HeNewFriendCell : UITableViewCell
@property(strong,nonatomic) AsynImageView *asyncImage;
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *signLabel;
@property(strong,nonatomic) UIButton *checkButton;
@property(strong,nonatomic) NSString *fuid;
@property(strong,nonatomic) NSString *uid;
@property(assign,nonatomic) id<agreeProtocol>agreeDelegate;


@end
