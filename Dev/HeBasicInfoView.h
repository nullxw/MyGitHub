//
//  HeBasicInfoView.h
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"
#import "HeSysbsModel.h"
#import "Dao.h"
#import "HeMeViewController.h"
#import "HeEnrollView.h"

#define isAutoDownloadKey   @"isAutoDownLoad"
#define isPushKey           @"isPush"
#define isAutoLoginKey      @"isAutoLogin"

#define isLoginOutKey       @"isLoginOutKey"

#define ACCOUNT_KEY         @"accountKey"
#define PASSWORD_KEY        @"passwordKey"

@interface HeBasicInfoView : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,DaoProtocol>

@property(strong,nonatomic)IBOutlet UITextField *accountTF;
@property(strong,nonatomic)IBOutlet UITextField *passwordTF;
@property(strong,nonatomic)IBOutlet UIButton *commitButton;

@property(strong,nonatomic)IBOutlet UIButton *enterHuoBaoButton;
@property(strong,nonatomic)IBOutlet UIButton *modifyInfoButton;
@property(strong,nonatomic)NSString *phoneStr;
@property(assign,nonatomic)int loadSucceedFlag;

-(IBAction)commitButtonClick:(id)sender;
-(IBAction)modifyButtonClick:(id)sender;
-(IBAction)enterButtonClick:(id)sender;

@end
