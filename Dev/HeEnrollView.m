//
//  HeEnrollView.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeEnrollView.h"
#import "HeCommitView.h"

@interface HeEnrollView ()

@end

@implementation HeEnrollView
@synthesize accountTF;
@synthesize getCheckCodeButton;
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
        label.text = @"注  册";
        [label sizeToFit];
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
    
    UIView *accountSpaceView = [[UIView alloc]init];
    accountSpaceView.backgroundColor = [UIColor clearColor];
    accountSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [accountTF setLeftView:accountSpaceView];
    [accountTF setLeftViewMode:UITextFieldViewModeAlways];
    
    accountTF.delegate = self;
    [getCheckCodeButton infoStyle];
}

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)enrollButtonClick:(id)sender
{
    [accountTF resignFirstResponder];
    if ([accountTF.text isEqualToString:@""] || accountTF.text == nil) {
        [self showTipLabelWith:@"手机号不能为空"];
        return;
    }
    Dao *shareDao = [Dao sharedDao];
    NSString *phone = accountTF.text;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"phone", nil];
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
        HeCommitView *commitView = [[HeCommitView alloc] initWithDic:myDic];
        commitView.phoneStr = [[NSString alloc] initWithString:accountTF.text];
        commitView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commitView animated:YES];
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
        if (range.location >= 11) {
            return NO;
        }
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
