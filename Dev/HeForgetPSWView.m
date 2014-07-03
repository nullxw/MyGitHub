//
//  HeForgetPSWView.m
//  huobao
//
//  Created by Tony He on 14-5-14.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeForgetPSWView.h"
#import "HeReSetPSWView.h"

#define PasswordMAXLength    13

@interface HeForgetPSWView ()

@end

@implementation HeForgetPSWView
@synthesize getcheckCodeButton;
@synthesize nextButton;
@synthesize accountTF;
@synthesize checkCodeTF;
@synthesize tipLabel1;
@synthesize tipLabel2;
@synthesize resendLabel;
@synthesize tipLabel3;

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
        label.text = @"忘记密码";
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
    
    [getcheckCodeButton successStyle];
    [nextButton infoStyle];
    accountTF.delegate = self;
    checkCodeTF.delegate = self;
    
    tipLabel1.hidden = YES;
    tipLabel2.hidden = YES;
    resendLabel.hidden = YES;
    nextButton.hidden = YES;
    
    accountTF.tag = 1;
    if ([[UIScreen mainScreen] bounds].size.height <= 480) {
        UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
        finishButton.title = @"完成";
        NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
        UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
        tb.items = bArray;
        accountTF.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    }
}

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finish:(id)sender
{
    if ([accountTF isFirstResponder]) {
        [accountTF resignFirstResponder];
    }
}

-(IBAction)getcheckCodeAction:(id)sender
{
    getcheckCodeButton.hidden = YES;
    nextButton.hidden = NO;
    tipLabel1.hidden = NO;
    tipLabel2.hidden = NO;
    resendLabel.hidden = NO;
    tipLabel3.hidden = YES;
    accountTF.text = nil;
    accountTF.placeholder = @"请输入验证码";
    accountTF.tag = 2;
    
}

-(IBAction)nextButtonClick:(id)sender
{
    HeReSetPSWView *resetPSWView = [[HeReSetPSWView alloc] init];
    resetPSWView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resetPSWView animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
