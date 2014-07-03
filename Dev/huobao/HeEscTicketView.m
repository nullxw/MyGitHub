//
//  HeEscTicketView.m
//  huobao
//
//  Created by Tony He on 14-5-17.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeEscTicketView.h"
#import "UIButton+Bootstrap.h"

@interface HeEscTicketView ()
@property(strong,nonatomic)IBOutlet AsynImageView *asyImage;
@property(strong,nonatomic)IBOutlet UIImageView *backgroundImage;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UILabel *timeLabel;
@property(strong,nonatomic)IBOutlet UILabel *addressLabel;
@property(strong,nonatomic)IBOutlet UILabel *numberLabel;
@property(strong,nonatomic)IBOutlet UILabel *infoLabel;
@property(strong,nonatomic)IBOutlet UIButton *addButton;
@property(strong,nonatomic)IBOutlet UIButton *releaseButton;
@property(strong,nonatomic)IBOutlet UITextField *numberTF;
@property(strong,nonatomic)IBOutlet UIButton *escButton;


@end

@implementation HeEscTicketView
@synthesize asyImage;
@synthesize backgroundImage;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize addressLabel;
@synthesize numberLabel;
@synthesize infoLabel;
@synthesize addButton;
@synthesize releaseButton;
@synthesize numberTF;
@synthesize escButton;


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
        label.text = @"退票";
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
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    finishButton.title = @"完成";
    NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    tb.items = bArray;
    numberTF.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    numberTF.delegate = self;
    UIView *accountSpaceView = [[UIView alloc]init];
    accountSpaceView.backgroundColor = [UIColor clearColor];
    accountSpaceView.frame = CGRectMake(0, 0, 10, 10);
    [numberTF setLeftView:accountSpaceView];
    [numberTF setLeftViewMode:UITextFieldViewModeAlways];
    asyImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
    asyImage.imageURL = @"http://365hh.cn//Upload/s_20140506084837858d0433-c0ad-44a2-9c11-8ac8fc0ca947.jpg";
    [escButton infoStyle];
    infoLabel.backgroundColor = [UIColor whiteColor];
}

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)escButtonClick:(id)sender
{
    if ([numberTF.text intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"退票数不能为零" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *infoString = [NSString stringWithFormat:@"退换门票数量 : 3张\n   共返还积分 : 9分"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退票确认" message:infoString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    [alert show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    if (alertView.tag == 100) {
        int intFlg = 0 ;//先是title intFlg = 0，当intFlg =1;message label
        for( UIView * view in alertView.subviews ){
            if( [view isKindOfClass:[UILabel class]] ){
                UILabel* label = (UILabel*) view;
                if(intFlg == 1){
                    label.textAlignment = NSTextAlignmentLeft;
                }
                intFlg = 1;
            }
            
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [self showTipLabelWith:@"退票成功"];
            [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
            break;
        }
        default:
            break;
    }
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
    [hud hide:YES afterDelay:1.0f];
}

-(IBAction)addOrReleaseButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            NSString *numStr = numberTF.text;
            int num = [numStr intValue];
            if (num == 0) {
                return;
            }
            else{
                num--;
                numberTF.text = [NSString stringWithFormat:@"%d",num];
            }
            break;
        }
        case 2:
        {
            NSString *numStr = numberTF.text;
            int num = [numStr intValue];
            num++;
            numberTF.text = [NSString stringWithFormat:@"%d",num];
            
            break;
        }
        default:
            break;
    }
}

-(void)finish:(id)sender
{
    [numberTF resignFirstResponder];
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
