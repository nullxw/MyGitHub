//
//  HeReSetPSWView.h
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "HeLoginView.h"

@interface HeReSetPSWView : UIViewController<UITextFieldDelegate>

@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UITextField *pswTF;
@property(strong,nonatomic)IBOutlet UITextField *cpswTF;

-(IBAction)loginButtonClick:(id)sender;

@end
