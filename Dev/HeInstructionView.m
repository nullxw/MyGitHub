//
//  HeInstructionView.m
//  com.mant.iosClient
//
//  Created by 何 栋明 on 13-11-13.
//  Copyright (c) 2013年 何栋明. All rights reserved.
//

#import "HeInstructionView.h"
#import "NGTestTabBarController.h"
#import "HeHuoViewController.h"
#import "HeBaoViewController.h"
#import "HePassportViewController.h"
#import "HeFriendViewController.h"
#import "HeMeViewController.h"
#import "HeInstructionView.h"
#import "HeAppDelegate.h"

#define DefaultTabBarImageHilightedTintColor             [UIColor colorWithRed:120.0f/255.0f green:202.0f/255.0f blue:255.0f/255.0f alpha:1.0]
#define DefaultTabBarTitleHilightedTintColor             [UIColor orangeColor]

@interface HeInstructionView ()
@property(strong,nonatomic)NSArray *launchArray;

@end

@implementation HeInstructionView
@synthesize loadSucceedFlag;
@synthesize launchArray;


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
        label.text = @"活    宝";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    myscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    myscrollView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:230.0f/255.0f];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 36)];
    images = [NSMutableArray arrayWithObjects:@"introduce1.png",@"introduce2.png",@"introduce3.png", nil];
    [self.view addSubview:myscrollView];
    [self setupPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    self.loadSucceedFlag = 1;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.loadSucceedFlag = 1;
}


-(void)setupPage
{
    myscrollView.delegate = self;
    [myscrollView setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:230.0f/255.0f]];
    [myscrollView setCanCancelContentTouches:NO];
    myscrollView.clipsToBounds = YES;
    myscrollView.scrollEnabled = YES;
    myscrollView.pagingEnabled = YES;
    myscrollView.directionalLockEnabled = NO;
    myscrollView.alwaysBounceHorizontal = NO;
    myscrollView.alwaysBounceVertical = NO;
    myscrollView.showsHorizontalScrollIndicator = NO;
    myscrollView.showsVerticalScrollIndicator = NO;
    
    NSInteger nimages = 0;
    CGFloat cx = 0;
    for (NSString *imagepath in images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagepath]];
        imageView.frame = CGRectZero;
        CGRect rect = myscrollView.frame;
        rect.size.height = self.view.bounds.size.height;
        rect.size.width = self.view.bounds.size.width;
        rect.origin.x = cx;
        rect.origin.y = 0;
        imageView.frame = rect;
        
        [myscrollView addSubview:imageView];
        
        if (nimages == [images count] - 1) {
            enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [enterButton setTitle:@"开启活宝之旅" forState:UIControlStateNormal];
            enterButton.frame = CGRectMake(rect.origin.x + 102, myscrollView.bounds.size.height - 100, 120, 40);
            [enterButton infoStyle];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) {
                [enterButton setFrame :CGRectMake(rect.origin.x + 102, myscrollView.bounds.size.height - 100, 120, 40)];
            }
            [enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [myscrollView addSubview:enterButton];
            
        }
        
        cx += myscrollView.frame.size.width;
        nimages++;
    }
    pageControl.numberOfPages = nimages;
    pageControl.currentPage = 0;
    [myscrollView setContentSize:CGSizeMake(cx, [myscrollView bounds].size.height)];
    
}

-(void)enterButtonClick:(id)sender
{
    [self performSelector:@selector(changeRootCon) withObject:nil afterDelay:0.5];
    
}

-(void)changeRootCon
{
    HeHuoViewController *huoVC = [[HeHuoViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *huoNav = [[UINavigationController alloc] initWithRootViewController:huoVC];
    [huoVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HeBaoViewController *baoVC = [[HeBaoViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *baoNav = [[UINavigationController alloc] initWithRootViewController:baoVC];
    [baoVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HePassportViewController *passportVC = [[HePassportViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *passportNav = [[UINavigationController alloc] initWithRootViewController:passportVC];
    [passportVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HeFriendViewController *friendVC = [[HeFriendViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *friendNav = [[UINavigationController alloc] initWithRootViewController:friendVC];
    [friendVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HeMeViewController *meVC = [[HeMeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
    [meVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    huoNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"活" image:[UIImage imageNamed:@"bao.png"] highlightedImage:[UIImage imageNamed:@"bao_hightlighted.png"]];
    huoNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    huoNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    huoNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    baoNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"宝" image:[UIImage imageNamed:@"huo.png"] highlightedImage:[UIImage imageNamed:@"huo_hightlighted.png"]];
    baoNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    baoNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    baoNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    passportNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"通行证" image:[UIImage imageNamed:@"passport.png"] highlightedImage:[UIImage imageNamed:@"passport_hightlighted.png"]];
    passportNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    passportNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    passportNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    friendNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"小伙伴" image:[UIImage imageNamed:@"friend.png"] highlightedImage:[UIImage imageNamed:@"friend_hightlighted.png"]];
    friendNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    friendNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    friendNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    meNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"我" image:[UIImage imageNamed:@"me.png"] highlightedImage:[UIImage imageNamed:@"me_hightlighted.png"]];
    meNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    meNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    meNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    NSArray *vcArray = [NSArray arrayWithObjects:huoNav,baoNav,passportNav,friendNav,meNav,nil];
    
    HeAppDelegate *myAppdelegate = (HeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NGTestTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:myAppdelegate];
    huoNav.delegate = tabBarController;
    baoNav.delegate = tabBarController;
    passportNav.delegate = tabBarController;
    friendNav.delegate = tabBarController;
    meNav.delegate = tabBarController;
    
    tabBarController.viewControllers = vcArray;
    myAppdelegate.window.rootViewController = tabBarController;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    pageControl.currentPage = page;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
