//
//  HeCommitView.h
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "Dao.h"
#import "MBProgressHUD.h"

@interface HeCommitView : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

@property(strong,nonatomic)IBOutlet UITextField *commitTF;
@property(strong,nonatomic)IBOutlet UIButton *resendButton;
@property(strong,nonatomic)IBOutlet UIButton *nextButton;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel;
@property(strong,nonatomic)NSString *phoneStr;
@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSDictionary *msgDic;

-(IBAction)resendButtonClick:(id)sender;
-(IBAction)nextButtonClick:(id)sender;
-(id)initWithDic:(NSDictionary *)dic;

@end
