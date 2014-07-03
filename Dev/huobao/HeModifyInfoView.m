//
//  HeModifyInfoView.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeModifyInfoView.h"
#import "CPTextViewPlaceholder.h"

@interface HeModifyInfoView ()
@property(strong,nonatomic)NSDictionary *settingDict;
@property(strong,nonatomic)CPTextViewPlaceholder *contentField;

@end

@implementation HeModifyInfoView
@synthesize modifyTF;
@synthesize settingDict;
@synthesize contentField;
@synthesize popToRoot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        popToRoot = NO;
    }
    return self;
}

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.settingDict = [[NSDictionary alloc] initWithDictionary:dict copyItems:NO];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        NSString *titleStirng = [dict objectForKey:@"defaultInfo"];
        label.text = [NSString stringWithFormat:@"编辑%@",titleStirng];
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
}

-(void)initControl
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    self.modifyTF.delegate = self;
    NSString *infoString = [settingDict objectForKey:@"info"];
    NSString *defaultString = [settingDict objectForKey:@"defaultInfo"];
    modifyTF.text = infoString;
    modifyTF.placeholder = defaultString;
    UIView *accountSpaceView = [[UIView alloc]init];
    accountSpaceView.backgroundColor = [UIColor clearColor];
    accountSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [modifyTF setLeftView:accountSpaceView];
    [modifyTF setLeftViewMode:UITextFieldViewModeAlways];
    
    NSIndexPath *indexPath = [self.settingDict objectForKey:@"indexPath"];
    if (indexPath.row == 3) {
        CGFloat field_height = 50.0;
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
        CGSize constraint = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20,2000);
        NSString *signString = infoString;
        CGSize size = [signString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
        if (size.height + 15 > 50.0) {
            field_height = size.height + 30;
        }
        self.contentField = [[CPTextViewPlaceholder alloc] init];
        contentField.layer.borderWidth = 1.0;
        contentField.layer.borderColor = [[UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f] CGColor];
        contentField.layer.cornerRadius = 2.0f;
        contentField.layer.masksToBounds = YES;
        self.contentField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        self.contentField.frame = CGRectMake(10, modifyTF.frame.origin.y, [[UIScreen mainScreen] bounds].size.width - 20, field_height);
        self.contentField.editable = YES;
        self.contentField.backgroundColor = [UIColor clearColor];
        self.contentField.returnKeyType = UIReturnKeyDefault;
        self.contentField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
        finishButton.title = @"完成";
        NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
        UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
        tb.items = bArray;
        contentField.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
        
        self.contentField.text = signString;
        self.contentField.placeholder = defaultString;
        [self.view addSubview:contentField];
        modifyTF.hidden = YES;
    }
    
    
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
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] init];
    saveButton.title = @"保存";
    saveButton.target = self;
    saveButton.action = @selector(saveInfo:);
    [saveButton setTintColor:[UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f]];
    self.navigationItem.rightBarButtonItem = saveButton;
}

-(void)saveInfo:(id)sender
{
    NSIndexPath *indexPath = [self.settingDict objectForKey:@"indexPath"];
    NSInteger row = indexPath.row;
    NSString *infoStirng = self.modifyTF.text;
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    switch (row) {
        case 1:
        {
            sysModel.user.nichen = infoStirng;
            break;
        }
        case 3:
        {
            infoStirng = contentField.text;
            sysModel.user.sign = infoStirng;
            break;
        }
        case 4:
        {
            sysModel.user.address = infoStirng;
            break;
        }
        case 5:
        {
            sysModel.user.phone = infoStirng;
            break;
        }
        case 6:
        {
            sysModel.user.email = infoStirng;
            break;
        }
            
        default:
            break;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"modifyUser" object:self];
    
    [self showTipLabelWith:@"修改成功"];
    [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
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


-(void)finish:(id)sender
{
    if ([contentField isFirstResponder]) {
        [contentField resignFirstResponder];
    }
    
}

-(void)backTolastView:(id)sender
{
    if (popToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
