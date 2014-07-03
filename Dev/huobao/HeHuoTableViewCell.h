//
//  HeHuoTableViewCell.h
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@interface HeHuoTableViewCell : UITableViewCell
@property(strong,nonatomic)AsynImageView *asyncImage;
@property(strong,nonatomic)UIView *bgImage;
@property(strong,nonatomic)UIView *lucencyView;
@property(strong,nonatomic)UIImageView *halfCorner;
@property(strong,nonatomic)UIImageView *halfCorner1;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UIImageView *timeIcon;
@property(strong,nonatomic)UIImageView *addressIcon;
@property(strong,nonatomic)UILabel *timeLabel;
@property(strong,nonatomic)UILabel *addressLabel;
@property(strong,nonatomic)UILabel *whiteLabel;

@end
