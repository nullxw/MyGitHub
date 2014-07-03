//
//  HeYaoHaoCell.h
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@interface HeYaoHaoCell : UITableViewCell
@property(strong,nonatomic) AsynImageView *asyncImage;
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *timeLabel;
@property(strong,nonatomic) UILabel *statueLabel;

@end
