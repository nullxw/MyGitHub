//
//  HeMeViewController.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeLoginView.h"
#import "HeMeTable.h"

@interface HeMeViewController : UIViewController<HeMeTableSelectProtocol>


@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UIImageView *logoImage;
@property(strong,nonatomic)IBOutlet UIImageView *me_bg_Image;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel;

-(IBAction)loginAction:(id)sender;

@end
