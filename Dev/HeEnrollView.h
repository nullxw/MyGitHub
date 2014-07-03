//
//  HeEnrollView.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"
#import "Dao.h"

@interface HeEnrollView : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

@property(strong,nonatomic)IBOutlet UITextField *accountTF;
@property(strong,nonatomic)IBOutlet UIButton *getCheckCodeButton;
@property(assign,nonatomic)int loadSucceedFlag;

-(IBAction)enrollButtonClick:(id)sender;

@end
