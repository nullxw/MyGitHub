//
//  HeBaoPiaoDetailView.m
//  huobao
//
//  Created by Tony He on 14-5-16.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeBaoPiaoDetailView.h"
#import "HeEscTicketView.h"
#import "HeGiveTicketView.h"
#import "HeActivityDetailView.h"

@interface HeBaoPiaoDetailView ()

@end

@implementation HeBaoPiaoDetailView
@synthesize bgImage;
@synthesize asyImage;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize addressLabel;
@synthesize numberLabel;
@synthesize activityButton;
@synthesize d_addressLabel;
@synthesize d_timeLabel;
@synthesize renshuLabel;
@synthesize priceLabel;
@synthesize menPiaoLabel;
@synthesize giveButton;
@synthesize escButton;
@synthesize bgLabel;
@synthesize myscrollview;
@synthesize piaoBgImage;
@synthesize imageurl;

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
        label.text = @"宝票详情";
        [label sizeToFit];
    }
    return self;
}

-(id)initWitgTypeID:(int)type
{
    self = [super init];
    if (self) {
        typeID = type;
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
    if (typeID == 2) {
        escButton.hidden = YES;
    }
    
}

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [timeLabel setTextColor:[UIColor grayColor]];
    [addressLabel setTextColor:[UIColor grayColor]];
    [activityButton defaultStyle];
    [activityButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [giveButton successStyle];
    [escButton infoStyle];
    
    bgLabel.backgroundColor = [UIColor whiteColor];
    
    asyImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
    asyImage.imageURL = imageurl;
    NSArray *childSubviews = self.view.subviews;
    for (UIView *view in childSubviews) {
        if (![view isMemberOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
            [myscrollview addSubview:view];
        }
    }
    CGFloat offset = 0.0f;
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        offset = 88.0f;
    }
    myscrollview.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + offset, self.view.bounds.size.width, 548);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        myscrollview.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + 20 + offset, self.view.bounds.size.width, 548);
        piaoBgImage.frame = CGRectMake(20, 12, 280, 85);
    }
    [self.view addSubview:myscrollview];
    [myscrollview setBackgroundColor:[UIColor clearColor]];
    [myscrollview setCanCancelContentTouches:NO];
    myscrollview.clipsToBounds = YES;
    myscrollview.scrollEnabled = YES;
    myscrollview.pagingEnabled = YES;
    myscrollview.directionalLockEnabled = NO;
    myscrollview.alwaysBounceHorizontal = NO;
    myscrollview.alwaysBounceVertical = NO;
    myscrollview.showsHorizontalScrollIndicator = NO;
    myscrollview.showsVerticalScrollIndicator = YES;
    myscrollview.delegate = self;
    [myscrollview setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//转赠
-(IBAction)giveButtonClick:(id)sender
{
    TKContactsMultiPickerController *contactList = [[TKContactsMultiPickerController alloc] initWithNibName:@"TKContactsMultiPickerController" bundle:nil];
  
    contactList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contactList animated:YES];
}

//退票
-(IBAction)escButtonClick:(id)sender
{
    HeEscTicketView *escTicketView = [[HeEscTicketView alloc] init];
    escTicketView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:escTicketView animated:YES];
}

//查看活动详情
-(IBAction)activityButtonClick:(id)sender
{
    HeActivityDetailView *activityView = [[HeActivityDetailView alloc] init];
    activityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
