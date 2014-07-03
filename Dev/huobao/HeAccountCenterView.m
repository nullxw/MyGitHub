//
//  HeAccountCenterView.m
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeAccountCenterView.h"
#import "AsynImageView.h"
#import "UIButton+Bootstrap.h"
#import "HePaySucceedView.h"

@interface HeAccountCenterView ()
@property(strong,nonatomic)IBOutlet AsynImageView *userImage;
@property(strong,nonatomic)IBOutlet UIImageView *bgImage;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UILabel *ticketLabel;
@property(strong,nonatomic)IBOutlet UILabel *addLabel;
@property(strong,nonatomic)IBOutlet UILabel *numLabel;
@property(strong,nonatomic)IBOutlet UIImageView *lineImage;
@property(strong,nonatomic)IBOutlet UIButton *commitButton;

@end

@implementation HeAccountCenterView
@synthesize userImage;
@synthesize bgImage;
@synthesize titleLabel;
@synthesize ticketLabel;
@synthesize numLabel;
@synthesize lineImage;
@synthesize commitButton;
@synthesize addLabel;

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
        label.text = @"结算中心";
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
    
    [commitButton successStyle];
    userImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
    bgImage.frame = CGRectMake(0, 0, 320, 200);
    
}

-(void)initView
{
    
}

-(void)backTolastView:(id)sender
{
//    HeSysbsModel *model = [HeSysbsModel getSysbsModel];
//    if (model.user != nil) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitButtonClick:(id)sender
{
    HePaySucceedView *paySucceedView = [[HePaySucceedView alloc] init];
    paySucceedView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paySucceedView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
