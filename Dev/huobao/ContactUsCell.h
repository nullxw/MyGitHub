//
//  ContactUsCell.h
//  huobao
//
//  Created by HeDongMing on 14-6-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@protocol ContactUsProtocol <NSObject>

//type 1:发短信  2:打电话
-(void)contactWithString:(NSString *)string type:(int)type;

@end

@interface ContactUsCell : UITableViewCell

@property(strong,nonatomic)AsynImageView *asyncImage;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *phoneLabel;
@property(strong,nonatomic)UIButton *messageIcon;
@property(strong,nonatomic)UIButton *callButton;
@property(assign,nonatomic)id<ContactUsProtocol> delegate;

@end
