//
//  HeGiveTicketCell.h
//  huobao
//
//  Created by Tony He on 14-5-26.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@interface HeGiveTicketCell : UITableViewCell

@property(strong,nonatomic)AsynImageView *asyncImage;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UIButton *releaseButton;
@property(strong,nonatomic)UILabel *numberLabel;
@property(strong,nonatomic)UIButton *addButton;

@end
