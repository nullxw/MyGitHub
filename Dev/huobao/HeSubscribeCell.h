//
//  HeSubscribeCell.h
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@interface HeSubscribeCell : UITableViewCell
@property(strong,nonatomic)AsynImageView *asyncImage;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UIImageView *timeIcon;
@property(strong,nonatomic)UILabel *timeLabel;
@property(strong,nonatomic)UIImageView *addressIcon;
@property(strong,nonatomic)UILabel *addressLabel;

@end
