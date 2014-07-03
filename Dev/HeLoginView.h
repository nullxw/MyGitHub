//
//  HeLoginView.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "Dao.h"
#import "MBProgressHUD.h"
#import "NSString+Catagory.h"
#import "BaseViewController.h"
#import "EMError.h"

#define isAutoDownloadKey   @"isAutoDownLoad"
#define isPushKey           @"isPush"
#define isAutoLoginKey      @"isAutoLogin"

#define isLoginOutKey       @"isLoginOutKey"

#define ACCOUNT_KEY         @"accountKey"
#define PASSWORD_KEY        @"passwordKey"

@interface HeLoginView : UIViewController<UITextFieldDelegate,DaoProtocol,MBProgressHUDDelegate>
{
    BOOL isAutoLogin;
    BOOL isLogout;
}

@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UIButton *enrollButton;
@property(strong,nonatomic)IBOutlet UIButton *fpswButton;
@property(strong,nonatomic)IBOutlet UITextField *accountTF;
@property(strong,nonatomic)IBOutlet UITextField *passwordTF;
@property(strong,nonatomic)IBOutlet UIImageView *bgImage;
@property(strong,nonatomic)IBOutlet UIButton *autologinButton;
@property(strong,nonatomic)UIView *sepline;//分割线
@property(assign,nonatomic)int loadSucceedFlag;

-(IBAction)loginButtonClick:(id)sender;
-(IBAction)forgetpasswordButtonClick:(id)sender;
-(IBAction)enrollButtonClick:(id)sender;

@end
