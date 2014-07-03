//
//  HeCommitView.m
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeCommitView.h"
#import "HeBasicInfoView.h"
#import "HeLoginView.h"

@interface HeCommitView ()

@end

@implementation HeCommitView
@synthesize commitTF;
@synthesize resendButton;
@synthesize nextButton;
@synthesize tipLabel;
@synthesize phoneStr;
@synthesize loadSucceedFlag;
@synthesize msgDic;

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
        label.text = @"验证身份";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        msgDic = [[NSDictionary alloc] initWithDictionary:dic];
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

-(void)initControl
{
    [resendButton successStyle];
    [nextButton infoStyle];

    commitTF.delegate = self;
    UIView *accountSpaceView = [[UIView alloc]init];
    accountSpaceView.backgroundColor = [UIColor clearColor];
    accountSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [commitTF setLeftView:accountSpaceView];
    [commitTF setLeftViewMode:UITextFieldViewModeAlways];
    commitTF.autocapitalizationType = UITextAutocorrectionTypeNo;
    
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
    NSString *msg = [msgDic objectForKey:@"msg"];
    if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
        msg = @"";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)backTolastView:(id)sender
{
    NSArray *navArray = self.navigationController.childViewControllers;
    for (UIViewController *conView in navArray) {
        if ([conView isMemberOfClass:[HeLoginView class]]) {
            [self.navigationController popToViewController:conView animated:YES];
            break;
        }
    }
}

-(void)finish:(id)sender
{
    if ([commitTF isFirstResponder]) {
        [commitTF resignFirstResponder];
    }
}

-(IBAction)resendButtonClick:(id)sender
{
    Dao *shareDao = [Dao sharedDao];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneStr,@"phone", nil];
    NSDictionary *myDic = [shareDao registWithPhone:dic];
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
        [self showTipLabelWith:@"验证码已发送，请注意查收"];
        NSString *msg = [myDic objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"";
            
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSString *msg = [myDic objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"";
           
        }
         [self showTipLabelWith:msg];
    }
}

-(IBAction)nextButtonClick:(id)sender
{
    Dao *shareDao = [Dao sharedDao];
    NSString *verifyCode = commitTF.text;
    NSString *phone = phoneStr;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:verifyCode,@"verifyCode",phone,@"phone",nil];
    NSDictionary *myDic = [shareDao validateWithCode:dic];
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
        HeBasicInfoView *basicInfo = [[HeBasicInfoView alloc] init];
        basicInfo.hidesBottomBarWhenPushed = YES;
        basicInfo.phoneStr = self.phoneStr;
        [self.navigationController pushViewController:basicInfo animated:YES];
    }
    else{
        NSString *msg = [myDic objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"";
        }
        [self showTipLabelWith:msg];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1) {
        if (range.location >= 20) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
