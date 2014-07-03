//
//  HeMeViewController.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeMeViewController.h"
#import "NGTestTabBarController.h"
#import "HeDetailInfoView.h"
#import "HeMyBaoBoxView.h"
#import "HeMyHuoBoxView.h"
#import "HeYaoHaoListView.h"
#import "HeJiFenHistoryView.h"
#import "HeSysbsModel.h"

@interface HeMeViewController ()
@property(strong,nonatomic)HeMeTable *meTable;

@end

@implementation HeMeViewController
@synthesize loginButton;
@synthesize logoImage;
@synthesize me_bg_Image;
@synthesize tipLabel;
@synthesize meTable;

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
        label.text = @"我";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUser];
    [self initView];
    [self initControl];
    
    
}

-(void)initUser
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updataData) name:@"modifyUser" object:nil];
    [notificationCenter addObserver:self selector:@selector(loginSucceed:) name:@"loginSucceed" object:nil];
    
    
}

-(void)initControl
{
    UIImageView *searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"modifyIcon.png"]];
    searchImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 40, (self.navigationController.navigationBar.frame.size.height - 35)/2, 40, 40);
    searchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyInfoAction:)];
    searchTap.numberOfTapsRequired = 1;
    searchTap.numberOfTouchesRequired = 1;
    [searchImage addGestureRecognizer:searchTap];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchImage];
    [rightBarItem setBackgroundImage:[UIImage imageNamed:@"modifyIcon.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [rightBarItem setBackgroundImage:[UIImage imageNamed:@"modifyIcon_hightlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [rightBarItem setTarget:self];
    rightBarItem.tag = 1;
    [rightBarItem setAction:@selector(modifyInfoAction:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [loginButton infoStyle];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if (sysModel.user.stateID != 1) {
        meTable.hidden = YES;
        loginButton.hidden = NO;
        logoImage.hidden = NO;
        me_bg_Image.hidden = NO;
        tipLabel.hidden = NO;
        if (loginButton == nil) {
            loginButton = [[UIButton alloc] init];
            loginButton.frame = CGRectMake(40, 180, 240, 40);
            [loginButton infoStyle];
            [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        [self.view addSubview:loginButton];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        meTable.hidden = NO;
        loginButton.hidden = YES;
        
        logoImage.hidden = YES;
        me_bg_Image.hidden = YES;
        tipLabel.hidden = YES;
    }
}

-(void)updataData
{
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    self.meTable.user = sysModel.user;
    self.meTable.user_headImage = nil;
    [meTable reloadData];
}

-(void)loginSucceed:(id)sender
{
    [self initControl];
    [self updataData];
}

-(void)initView
{
    self.meTable = [[HeMeTable alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    meTable.selectDelegate = self;
    [self.view addSubview:meTable];
}

-(void)modifyInfoAction:(id)sender
{
    HeDetailInfoView *detailInfo = [[HeDetailInfoView alloc] initWithNibName:nil bundle:nil];
    
    detailInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailInfo animated:YES];
}

-(IBAction)loginAction:(id)sender
{
    HeLoginView *loginView = [[HeLoginView alloc] initWithNibName:nil bundle:nil];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

-(void)selectTableWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        loginButton.hidden = NO;
        logoImage.hidden = NO;
        me_bg_Image.hidden = NO;
        tipLabel.hidden = NO;
        self.meTable.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 1:
        {
            switch (row) {
                case 0:
                {
                    HeMyBaoBoxView *baoView = [[HeMyBaoBoxView alloc] init];
                    baoView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:baoView animated:YES];
                    break;
                }
                case 1:
                {
                    HeMyHuoBoxView *huoBox = [[HeMyHuoBoxView alloc] init];
                    huoBox.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:huoBox animated:YES];
                    break;
                }
                case 2:
                {
                    HeYaoHaoListView *yaohaoList = [[HeYaoHaoListView alloc] init];
                    yaohaoList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:yaohaoList animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (row) {
                case 0:
                {
                    HeJiFenHistoryView *jifenList = [[HeJiFenHistoryView alloc] init];
                    jifenList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:jifenList animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyUser" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSucceed" object:nil];
}

@end
