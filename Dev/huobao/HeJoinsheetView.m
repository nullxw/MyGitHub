//
//  HeJoinsheetView.m
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeJoinsheetView.h"
#import "CPTextViewPlaceholder.h"
#import "HeAccountCenterView.h"
#import "CBTextView.h"

@interface HeJoinsheetView ()
@property(strong,nonatomic)IBOutlet UITextField *actorTF;
@property(strong,nonatomic)IBOutlet UITextField *gradeTF;
@property(strong,nonatomic)IBOutlet UITextField *contactTF;
@property(strong,nonatomic)IBOutlet CPTextViewPlaceholder *lastTF;
@property(strong,nonatomic)NSDictionary *activityDict;

@end

@implementation HeJoinsheetView
@synthesize actorTF;
@synthesize gradeTF;
@synthesize contactTF;
@synthesize lastTF;
@synthesize activityDict;
@synthesize loadSucceedFlag;
@synthesize type;

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
        label.text = @"活动报名表";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithActivityDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        activityDict = [[NSDictionary alloc] initWithDictionary:dic];
        NSLog(@"activityDict = %@",activityDict);
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
}

-(void)initView
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.title = @"提交";
    [rightButton setTintColor:[UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f]];
    [rightButton setTarget:self];
    [rightButton setAction:@selector(commitSheet:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finish:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];

    UIView *actorSpaceView = [[UIView alloc]init];
    actorSpaceView.frame = CGRectMake(0, 0, 80, 40);
    UILabel *actorlabel = [[UILabel alloc] init];
    actorlabel.backgroundColor = [UIColor clearColor];
    actorlabel.textColor = [UIColor grayColor];
    actorlabel.textAlignment = NSTextAlignmentCenter;
    actorlabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    actorlabel.text = @"参与者";
    actorlabel.frame = actorSpaceView.frame;
    [actorSpaceView addSubview:actorlabel];
    
    UIImageView *tfline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tfline.png"]];
    tfline.frame = CGRectMake(78, 10, 1, 20);
    [actorSpaceView addSubview:tfline];
    [actorTF setLeftViewMode:UITextFieldViewModeAlways];
    [actorTF setLeftView:actorSpaceView];
    
    UIView *gradeSpaceView = [[UIView alloc]init];
    gradeSpaceView.frame = CGRectMake(0, 0, 80, 40);
    UILabel *gradelabel = [[UILabel alloc] init];
    gradelabel.backgroundColor = [UIColor clearColor];
    gradelabel.textColor = [UIColor grayColor];
    gradelabel.textAlignment = NSTextAlignmentCenter;
    gradelabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    gradelabel.text = @"班级";
    gradelabel.frame = actorSpaceView.frame;
    [gradeSpaceView addSubview:gradelabel];
    
    UIImageView *gradetfline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tfline.png"]];
    gradetfline.frame = CGRectMake(78, 10, 1, 20);
    [gradeSpaceView addSubview:gradetfline];
    [gradeTF setLeftViewMode:UITextFieldViewModeAlways];
    [gradeTF setLeftView:gradeSpaceView];
    
    UIView *contactSpaceView = [[UIView alloc]init];
    contactSpaceView.frame = CGRectMake(0, 0, 80, 40);
    UILabel *contactlabel = [[UILabel alloc] init];
    contactlabel.backgroundColor = [UIColor clearColor];
    contactlabel.textColor = [UIColor grayColor];
    contactlabel.textAlignment = NSTextAlignmentCenter;
    contactlabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    contactlabel.text = @"联系方式";
    contactlabel.frame = actorSpaceView.frame;
    [contactSpaceView addSubview:contactlabel];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] init];
    nextButton.title = @"下一项";
    nextButton.target = self;
    nextButton.action = @selector(finish:);

    NSArray *nextButtonArray = [NSArray arrayWithObjects:nextButton, nil];
    UIToolbar *nextButtontb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    nextButtontb.items = nextButtonArray;
    contactTF.inputAccessoryView = nextButtontb;
    UIImageView *contacttfline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tfline.png"]];
    contacttfline.frame = CGRectMake(78, 10, 1, 20);
    [contactSpaceView addSubview:contacttfline];
    [contactTF setLeftViewMode:UITextFieldViewModeAlways];
    [contactTF setLeftView:contactSpaceView];
    
    lastTF.hidden = YES;
    CGRect frame = lastTF.frame;
    lastTF = [[CPTextViewPlaceholder alloc] init];
    lastTF.frame = frame;
    lastTF.placeholder = @"感兴趣的事";
    lastTF.layer.cornerRadius = 5.0f;
    lastTF.layer.borderWidth = 1.0f;
    lastTF.layer.borderColor = [[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0] CGColor];
    lastTF.layer.masksToBounds = YES;
    lastTF.delegate = self;
    lastTF.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [self.view addSubview:lastTF];
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    finishButton.title = @"完成";
    NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    tb.items = bArray;
    lastTF.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    lastTF.returnKeyType = UIReturnKeyDefault;
    lastTF.autocorrectionType = UITextAutocorrectionTypeNo;
    
    actorTF.delegate = self;
    gradeTF.delegate = self;
    contactTF.delegate = self;
    
}

-(void)commitSheet:(id)sender
{
    if ([actorTF.text isEqualToString:@""] || actorTF.text == nil) {
        [self showTipLabelWith:@"请输入参与者"];
        return;
    }
//    if ([gradeTF.text isEqualToString:@""] || gradeTF.text == nil) {
//        [self showTipLabelWith:@"请输入参与者"];
//        return;
//    }
    if ([contactTF.text isEqualToString:@""] || contactTF.text == nil) {
        [self showTipLabelWith:@"请输入联系方式"];
        return;
    }
//    if ([actorTF.text isEqualToString:@""] || actorTF.text == nil) {
//        [self showTipLabelWith:@"请输入参与者"];
//        return;
//    }
    
    self.loadSucceedFlag = 0;
    [self showTipLabelWith:@"正在提交..."];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    NSString *userName = sysModel.user.nichen;
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    
    NSString *tid = [activityDict objectForKey:@"id"];
    if (tid == nil || [tid isMemberOfClass:[NSNull class]]) {
        tid = @"";
    }
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;
    
    NSDictionary *joinDict = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid",tid,@"tid",userName,@"username",[NSNumber numberWithInt:type],@"type", nil];
    [shareDao asyncJoinActivityWith:joinDict];
}

-(void)requestSucceedWithStateID:(int)stateid withErrorStirng:(NSString *)errorString
{
    self.loadSucceedFlag = 1;
    if (stateid != 1) {
        [self showTipLabelWith:errorString];
    }
}

-(void)requestSucceedWithDic:(NSDictionary *)receiveDic
{
    self.loadSucceedFlag = 1;
    NSString *stateStr = [receiveDic objectForKey:@"state"];
    if (stateStr == nil || [stateStr isMemberOfClass:[NSNull class]]) {
        stateStr = @"-1";
    }
    int stateid = [stateStr intValue];
    if (stateid != 1) {
        NSString *msg = [receiveDic objectForKey:@"msg"];
        if ([msg isMemberOfClass:[NSNull class]] || msg == nil) {
            msg = @"服务器出错";
        }
        [self showTipLabelWith:msg];
        return;
    }
    
    HePaySucceedView *paySucceedView = [[HePaySucceedView alloc] initWithDic:activityDict];
    paySucceedView.type = type;
    paySucceedView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paySucceedView animated:YES];
    
}

-(void)next:(UIBarButtonItem *)sender
{
    if ([contactTF isFirstResponder]) {
        [contactTF resignFirstResponder];
        [lastTF becomeFirstResponder];
    }
}

-(void)finish:(id)sender
{
    if ([actorTF isFirstResponder]) {
        [actorTF resignFirstResponder];
    }
    else if ([gradeTF isFirstResponder]) {
        [gradeTF resignFirstResponder];
    }
    else if ([contactTF isFirstResponder]) {
//        [contactTF resignFirstResponder];
        [lastTF becomeFirstResponder];
    }
    else if ([lastTF isFirstResponder]) {
        [lastTF resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([actorTF isFirstResponder]) {
        [gradeTF becomeFirstResponder];
    }
    else if ([gradeTF isFirstResponder]) {
        [contactTF becomeFirstResponder];
    }
    else if ([contactTF isFirstResponder]) {
        [lastTF becomeFirstResponder];
    }
    else if ([lastTF isFirstResponder]) {
        [lastTF resignFirstResponder];
    }
    
    return YES;
    
}

-(void)showTipLabelWith:(NSString*)string
{
    if (self.view.window == nil) {
        return;
    }
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
    if (self.view.window == nil) {
        return;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = string;
    [HUD showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
