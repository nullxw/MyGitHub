//
//  HeLoginView.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeLoginView.h"
#import "HeForgetPSWView.h"
#import "HeEnrollView.h"

#define PasswordMAXLength    13

@interface HeLoginView ()


@end

@implementation HeLoginView
@synthesize loginButton;
@synthesize accountTF;
@synthesize passwordTF;
@synthesize fpswButton;
@synthesize enrollButton;
@synthesize bgImage;
@synthesize loadSucceedFlag;
@synthesize autologinButton;
@synthesize sepline;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"登  录";
        [label sizeToFit];
        
        isLogout = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isLoginOutKey];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    isLogout = [(NSNumber *)[userDefaults objectForKey:isLoginOutKey] boolValue];
    isAutoLogin = [[userDefaults objectForKey:isAutoLoginKey] boolValue];
    if (isAutoLogin && isLogout)
    {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loginButtonClick:) object:nil];
        [thread start];
    }
    if (isAutoLogin && isLogout)
    {
        [self loginButtonClick:nil];
    }
    
}
-(void)initControl
{
    self.bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFirstResponder:)];
    cancelTap.numberOfTapsRequired = 1;
    cancelTap.numberOfTouchesRequired = 1;
    [self.bgImage addGestureRecognizer:cancelTap];
    
    [loginButton infoStyle];
    autologinButton.tag = 1;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *beforeAccount = [userDefaults objectForKey:ACCOUNT_KEY];
    NSString *beforePaw = [userDefaults objectForKey:PASSWORD_KEY];
    isAutoLogin = [[userDefaults objectForKey:isAutoLoginKey] boolValue];
    if (isAutoLogin) {
        autologinButton.tag = 2;
        [autologinButton setImage:[UIImage imageNamed:@"check_box_yes.png"] forState:UIControlStateNormal];
    }
    self.accountTF.text = beforeAccount;
    self.passwordTF.text = beforePaw;
    
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.frame = CGRectMake(0, 0, 40, 40);
    
    UIImageView *accountSpaceView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newuser.png"]];
    accountSpaceView.frame = CGRectMake(5, 10, 20, 20);
    [spaceView addSubview:accountSpaceView];
    UIImageView *tfline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tfline.png"]];
    tfline.frame = CGRectMake(35, 10, 1, 20);
    [spaceView addSubview:tfline];
    
    
    UIView *pspaceView = [[UIView alloc]init];
    pspaceView.frame = CGRectMake(0, 0, 40, 40);
    
    UIImageView *pswSpaceView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pwd.png"]];
    pswSpaceView.frame = CGRectMake(5, 10, 20, 20);
    [pspaceView addSubview:pswSpaceView];
    UIImageView *tfline1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tfline.png"]];
    tfline1.frame = CGRectMake(35, 10, 1, 20);
    [pspaceView addSubview:tfline1];
    
    [accountTF setLeftView:spaceView];
    [passwordTF setLeftView:pspaceView];
    [accountTF setLeftViewMode:UITextFieldViewModeAlways];
    [passwordTF setLeftViewMode:UITextFieldViewModeAlways];
    
    accountTF.delegate = self;
    passwordTF.delegate = self;
    
    
    CGFloat buttonWidth = self.view.bounds.size.width/2;
    CGFloat buttonHight = 40.0;
    CGFloat buttonX = 0.f;
    CGFloat buttonY = ([[UIScreen mainScreen] bounds].size.height - 44.0 - 20) - buttonHight;
    fpswButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHight);
    enrollButton.frame = CGRectMake(buttonX + buttonWidth, buttonY, buttonWidth, buttonHight);
    sepline = [[UIView alloc] init];
    sepline.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1];
    sepline.frame = CGRectMake(buttonX + buttonWidth - 1, buttonY + 8, 2, buttonHight - 16);
    [self.view addSubview:sepline];
    [enrollButton infoStyleWithNoCorner];
    [fpswButton infoStyleWithNoCorner];
    [enrollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fpswButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:fpswButton];
    [self.view addSubview:enrollButton];
    
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_backItem.png"]];
    backImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 30, (self.navigationController.navigationBar.frame.size.height - 30)/2, 25, 25);
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTolastView:)];
    backTap.numberOfTapsRequired = 1;
    backTap.numberOfTouchesRequired = 1;
    [backImage addGestureRecognizer:backTap];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backImage];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"btn_backItem.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"btn_backItem_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [leftBarItem setTarget:self];
    [leftBarItem setAction:@selector(backTolastView:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
}

-(void)initView
{
    
}

-(IBAction)autoLoginButtonClick:(UIButton *)button
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (button.tag == 1) {
        button.tag = 2;
        [button setImage:[UIImage imageNamed:@"check_box_yes.png"] forState:UIControlStateNormal];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isAutoLoginKey];
    }
    else{
        button.tag = 1;
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isAutoLoginKey];
        [button setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
    }
}
-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/****判断账号是否合法****/
-(BOOL)isAccountVaild
{
    /****先判断账号是否为空****/
    if ([accountTF.text isEqualToString:@""] || accountTF.text == nil) {
        [self showTipLabelWith:@"账号不能为空"];
        return NO;
    }
//    NSString *trimString  = [NSString trim:accountTF.text];
//    const char *trimCString = [trimString UTF8String];
//    NSInteger length = [trimString length];
//    if (length != 11) {
//        [self showTipLabelWith:@"手机号格式不正确"];
//        return NO;
//    }
//    for (int i = 0; i<length; i++) {
//        if (*(trimCString+i)<48 || *(trimCString+i)>57) {
//            [self showTipLabelWith:@"手机号格式不正确"];
//            return NO;
//        }
//    }
    return YES;
}

//login method
-(IBAction)loginButtonClick:(id)sender
{
   
    if ([accountTF isFirstResponder]) {
        [accountTF resignFirstResponder];
    }
    if ([passwordTF isFirstResponder]) {
        [passwordTF resignFirstResponder];
    }
    if (![self isAccountVaild]) {
        return;
    }
    
    if (passwordTF.text == nil || [passwordTF.text isEqualToString:@""]) {
        [self showTipLabelWith:@"密码不能为空"];
        return;
    }
    
    [self IMLogin:nil];
    return;
    
    Dao *shareDao = [Dao sharedDao];
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [loginDic setObject:self.accountTF.text forKey:@"userName"];
    [loginDic setObject:self.passwordTF.text forKey:@"password"];
    shareDao.daoDelegate = self;
    self.loadSucceedFlag = 0;
    [self showLoadLabel:@"登录中..."];
    
    
    
    [shareDao loginRequestWithdict:loginDic];
    
}

-(void)requestSucceedWithStateID:(int)stateid withErrorStirng:(NSString *)errorString
{
    self.loadSucceedFlag = 1;
    if (stateid == 1) {
        /***环信那边的登录***/
        
        
        return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isLoginOutKey];
        [userDefaults setObject:accountTF.text forKey:ACCOUNT_KEY];
        [userDefaults setObject:passwordTF.text forKey:PASSWORD_KEY];
        [userDefaults synchronize];
        
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"loginSucceed" object:nil userInfo:nil];
        [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
    }
    else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isLoginOutKey];
        [userDefaults setObject:nil forKey:ACCOUNT_KEY];
        [userDefaults setObject:nil forKey:PASSWORD_KEY];
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isAutoLoginKey];
        [userDefaults synchronize];
        
        [self showTipLabelWith:errorString];
    }
}

//forgetpassword method
-(IBAction)forgetpasswordButtonClick:(id)sender
{
    HeForgetPSWView *fpswView = [[HeForgetPSWView alloc] init];
    fpswView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fpswView animated:YES];
}

//enroll method
-(IBAction)enrollButtonClick:(id)sender
{
    [self doRegister:nil];
    
    return;
    
    HeEnrollView *enrollView = [[HeEnrollView alloc] init];
    enrollView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:enrollView animated:YES];
}

-(void)cancelFirstResponder:(UITapGestureRecognizer*)tap
{
    if ([accountTF isFirstResponder]) {
        [accountTF resignFirstResponder];
    }
    if ([passwordTF isFirstResponder]) {
        [passwordTF resignFirstResponder];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1) {
        if (range.location >= 11) {
            return NO;
        }
    }else if (textField.tag == 2){
        if (range.location >= PasswordMAXLength) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            [passwordTF becomeFirstResponder];
            break;
        }
        case 2:
        {
            if ([passwordTF isFirstResponder]) {
                [passwordTF resignFirstResponder];
            }
            break;
        }
        default:
            break;
    }
    return YES;
}

/****环信那边的来注册****/
- (void)doRegister:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:accountTF.text
                                                         password:passwordTF.text
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         [self hideHud];
         
         if (!error) {
             TTAlertNoTitle(@"注册成功,请登录");
         }else{
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerDuplicatedAccount:
                     TTAlertNoTitle(@"您注册的用户已存在!");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"注册失败");
                     break;
             }
         }
     } onQueue:nil];
}

/***环信那边的登录***/
- (void)IMLogin:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:accountTF.text
                                                        password:passwordTF.text
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             /****现在才算真正的登录成功****/
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isLoginOutKey];
             [userDefaults setObject:accountTF.text forKey:ACCOUNT_KEY];
             [userDefaults setObject:passwordTF.text forKey:PASSWORD_KEY];
             [userDefaults synchronize];
             
             
             NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
             [center postNotificationName:@"loginSucceed" object:nil userInfo:nil];
             [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(@"用户名或密码错误");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"登录失败");
                     break;
             }
         }
     } onQueue:nil];
}

-(void)showLoadLabel:(NSString*)string
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = string;
    [HUD showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}

-(void)isLoadSucceed
{
    while (self.loadSucceedFlag == 0);
}

-(void)showTipLabelWith:(NSString*)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = string;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
