//
//  HeForgetPSWView.h
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"

@interface HeForgetPSWView : UIViewController<UITextFieldDelegate>

@property(strong,nonatomic)IBOutlet UIButton *getcheckCodeButton;
@property(strong,nonatomic)IBOutlet UIButton *nextButton;
@property(strong,nonatomic)IBOutlet UITextField *accountTF;
@property(strong,nonatomic)IBOutlet UITextField *checkCodeTF;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel1;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel2;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel3;
@property(strong,nonatomic)IBOutlet UILabel *resendLabel;

-(IBAction)getcheckCodeAction:(id)sender;
-(IBAction)nextButtonClick:(id)sender;

@end
