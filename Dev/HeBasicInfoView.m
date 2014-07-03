//
//  HeBasicInfoView.m
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeBasicInfoView.h"
#import "HeLoginView.h"
#import "HeDetailInfoView.h"

#define PasswordMAXLength    13

@interface HeBasicInfoView ()

@end

@implementation HeBasicInfoView
@synthesize accountTF;
@synthesize passwordTF;
@synthesize commitButton;
@synthesize enterHuoBaoButton;
@synthesize modifyInfoButton;
@synthesize phoneStr;
@synthesize loadSucceedFlag;

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
        label.text = @"基本信息";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControl];
    [self initView];
}

-(void)initControl
{
    [commitButton infoStyle];
    [enterHuoBaoButton successStyle];
    [modifyInfoButton dangerStyle];
    enterHuoBaoButton.hidden = YES;
    modifyInfoButton.hidden = YES;
    
    accountTF.delegate = self;
    passwordTF.delegate = self;
    
    
    UIView *accountSpaceView = [[UIView alloc]init];
    accountSpaceView.backgroundColor = [UIColor clearColor];
    accountSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [accountTF setLeftView:accountSpaceView];
    [accountTF setLeftViewMode:UITextFieldViewModeAlways];
    
    UIView *pswSpaceView = [[UIView alloc]init];
    pswSpaceView.backgroundColor = [UIColor clearColor];
    pswSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [passwordTF setLeftView:pswSpaceView];
    [passwordTF setLeftViewMode:UITextFieldViewModeAlways];
    
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

-(void)finish:(id)sender
{
    if ([accountTF isFirstResponder]) {
        [accountTF resignFirstResponder];
    }
    if ([passwordTF isFirstResponder]) {
        [passwordTF resignFirstResponder];
    }
}

-(void)backToRoot
{
    NSArray *navArray = self.navigationController.childViewControllers;
    for (UIViewController *conView in navArray) {
        if ([conView isMemberOfClass:[HeMeViewController class]]) {
            [self.navigationController popToViewController:conView animated:YES];
            break;
        }
    }
}

-(void)backTolastView:(id)sender
{
    NSArray *navArray = self.navigationController.childViewControllers;
    for (UIViewController *conView in navArray) {
        if ([conView isMemberOfClass:[HeEnrollView class]]) {
            [self.navigationController popToViewController:conView animated:YES];
            break;
        }
    }
}

-(void)loginButtonClick:(id)sender
{
    Dao *shareDao = [Dao sharedDao];
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [loginDic setObject:self.phoneStr forKey:@"userName"];
    [loginDic setObject:self.passwordTF.text forKey:@"password"];
    shareDao.daoDelegate = self;
    self.loadSucceedFlag = 0;
    [self showLoadLabel:@"注册成功，登录中..."];
    [shareDao loginRequestWithdict:loginDic];
    
}

-(void)requestSucceedWithStateID:(int)stateid withErrorStirng:(NSString *)errorString
{
    self.loadSucceedFlag = 1;
    if (stateid == 1) {
//        accountTF.hidden = YES;
//        passwordTF.hidden = YES;
//        commitButton.hidden = YES;
//        [commitButton removeFromSuperview];
//        enterHuoBaoButton.hidden = NO;
//        modifyInfoButton.hidden = NO;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"loginSucceed" object:nil userInfo:nil];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isLoginOutKey];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isAutoLoginKey];
        [userDefaults setObject:phoneStr forKey:ACCOUNT_KEY];
        [userDefaults setObject:passwordTF.text forKey:PASSWORD_KEY];
        [userDefaults synchronize];
        
        
        [self showTipLabelWith:@"登录成功"];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.5];
        
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

-(BOOL)isAccountVaild
{
    /****先判断账号是否为空****/
    if ([accountTF.text isEqualToString:@""] || accountTF.text == nil) {
        [self showTipLabelWith:@"昵称不能为空"];
        return NO;
    }
    
    return YES;
}

-(IBAction)commitButtonClick:(id)sender
{
    Dao *shareDao = [Dao sharedDao];
    NSString *password = passwordTF.text;
    NSString *phone = self.phoneStr;
    NSString *nickname = self.accountTF.text;
    
    if (![self isAccountVaild]) {
        return;
    }
    
    if (passwordTF.text == nil || [passwordTF.text isEqualToString:@""]) {
        [self showTipLabelWith:@"密码不能为空"];
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"phone",password,@"password",nickname,@"nickname", nil];
    NSDictionary *myDic = [shareDao registerWithDic:dic];
    if (myDic == nil) {
        [self showTipLabelWith:@"请求超时，请重试"];
        return;
    }
    NSLog(@"%@",myDic);
    NSString *stateidString = [myDic objectForKey:@"state"];
    if (stateidString == nil || [stateidString isMemberOfClass:[NSNull class]]) {
        stateidString = @"";
    }
    int stateid = [stateidString intValue];
    if (stateid == 1) {
        
        [self loginButtonClick:nil];
        
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center postNotificationName:@"loginSucceed" object:nil userInfo:nil];
//        
//        HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
//        sysModel.user = [[HeUser alloc] init];
//        sysModel.user.userImage = [[AsynImageView alloc] init];
//        sysModel.user.userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
//        sysModel.user.phone = self.phoneStr;
//        sysModel.user.nichen = self.accountTF.text;
//        sysModel.user.stateID = 1;
        UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noImage.png"]];
        backImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 30, (self.navigationController.navigationBar.frame.size.height - 30)/2, 25, 25);
        backImage.userInteractionEnabled = YES;
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backImage];
        [leftBarItem setBackgroundImage:[UIImage imageNamed:@"noImage.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [leftBarItem setBackgroundImage:[UIImage imageNamed:@"noImage.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        self.navigationItem.leftBarButtonItem = leftBarItem;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"注册成功";
        [label sizeToFit];
        

        
//        [self loginButtonClick:nil];
        

    }
    else{
        NSString *msg = [myDic objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"";
        }
        [self showTipLabelWith:msg];
    }
    
}

-(IBAction)modifyButtonClick:(id)sender
{
    HeDetailInfoView *modifyInfoView = [[HeDetailInfoView alloc] init];
    modifyInfoView.popToRoot = YES;
    modifyInfoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyInfoView animated:YES];
}

-(IBAction)enterButtonClick:(id)sender
{
    [self .navigationController popToRootViewControllerAnimated:YES];
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
    [textField resignFirstResponder];
    if (textField.tag == 1) {
        [passwordTF becomeFirstResponder];
    }
    
    return YES;
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

-(void)isLoadSucceed
{
    while(self.loadSucceedFlag == 0);
}

-(void)showLoadLabel:(NSString*)string
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = string;
    [HUD showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
