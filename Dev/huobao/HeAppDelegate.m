//
//  HeAppDelegate.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeAppDelegate.h"
#import "NGTestTabBarController.h"
#import "HeHuoViewController.h"
#import "HeBaoViewController.h"
#import "HePassportViewController.h"
#import "HeFriendViewController.h"
#import "HeMeViewController.h"
#import "HeInstructionView.h"
#import "HeSysbsModel.h"
#import "Dao.h"

#define DefaultTabBarImageHilightedTintColor             [UIColor colorWithRed:65.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0]
#define DefaultTabBarTitleHilightedTintColor             [UIColor colorWithRed:65.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0]

BMKMapManager* _mapManager;
@implementation HeAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    Dao *shareDao = [Dao sharedDao];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.window.frame =  CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
//        UIApplication *myApp = [UIApplication sharedApplication];
//        [myApp setStatusBarStyle: UIStatusBarStyleLightContent];
//    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(65.0f, 164.0f, 220.0f, 1)];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	NSString *apnsCertName = nil;
#if DEBUG
	apnsCertName = @"huobaoAppPushCer";
#else
	apnsCertName = @"huobaoAppPush_ProductionCer";
#endif
	[[EaseMob sharedInstance] registerSDKWithAppKey:@"jitsuntech#huobaoapp" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] enableBackgroundReceiveMessage];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self initplatform];
    
    NSDictionary* dic =[[NSBundle mainBundle] infoDictionary];
    /****  读取当前应用的版本号  ****/
    NSString *versionInfo = [dic objectForKey:@"CFBundleShortVersionString"];
    /****  读取上一次应用运行的版本号  ****/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"launch.plist"];
    
    NSThread *clearThread = [[NSThread alloc] initWithTarget:self selector:@selector(clearTmpfile) object:nil];
    [clearThread start];
    
    NSDictionary *launchDic = [[NSDictionary alloc] initWithContentsOfFile:filename];
    
    if (launchDic == nil) {
        NSString *versionInfo = [dic objectForKey:@"CFBundleShortVersionString"];
        launchDic = [[NSDictionary alloc] initWithObjectsAndKeys:versionInfo,@"lastVersion" ,nil];
        [launchDic writeToFile:filename atomically:YES];
        /****  进入使用介绍界面  ****/
        HeInstructionView *introduceView = [[HeInstructionView alloc] init];
        self.window.rootViewController = introduceView;
        [self.window makeKeyAndVisible];
        return YES;
    }
    else{
        NSString *lastVersion = [launchDic objectForKey:@"lastVersion"];
        BOOL showInstruction = [[dic objectForKey:@"ShowInstruction"] boolValue];
        if ((![lastVersion isEqualToString:versionInfo]) && showInstruction) {
            
            NSString *versionInfo = [dic objectForKey:@"CFBundleShortVersionString"];
            launchDic = [[NSDictionary alloc] initWithObjectsAndKeys:versionInfo,@"lastVersion" ,nil];
            [launchDic writeToFile:filename atomically:YES];
            /****  进入使用介绍界面  ****/
            HeInstructionView *introduceView = [[HeInstructionView alloc] init];
            self.window.rootViewController = introduceView;
            [self.window makeKeyAndVisible];
            return YES;
        }
    }
    
    HeHuoViewController *huoVC = [[HeHuoViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *huoNav = [[UINavigationController alloc] initWithRootViewController:huoVC];
//    [huoVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    ContactsViewController *baoVC = [[ContactsViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *baoNav = [[UINavigationController alloc] initWithRootViewController:baoVC];
//    [baoVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HePassportViewController *passportVC = [[HePassportViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *passportNav = [[UINavigationController alloc] initWithRootViewController:passportVC];
//    [passportVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    ChatListViewController *friendVC = [[ChatListViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *friendNav = [[UINavigationController alloc] initWithRootViewController:friendVC];
//    [friendVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    HeMeViewController *meVC = [[HeMeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
//    [meVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    huoNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"活" image:[UIImage imageNamed:@"huo.png"] highlightedImage:[UIImage imageNamed:@"huo_hightlighted.png"]];
    huoNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    huoNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    huoNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    baoNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"通信录" image:[UIImage imageNamed:@"bao.png"] highlightedImage:[UIImage imageNamed:@"bao_hightlighted.png"]];
    baoNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    baoNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    baoNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    passportNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"通行证" image:[UIImage imageNamed:@"passport.png"] highlightedImage:[UIImage imageNamed:@"passport_hightlighted.png"]];
    passportNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    passportNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    passportNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;

    friendNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"会话" image:[UIImage imageNamed:@"friend.png"] highlightedImage:[UIImage imageNamed:@"friend_hightlighted.png"]];
    friendNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    friendNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    friendNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    meNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"我" image:[UIImage imageNamed:@"me.png"] highlightedImage:[UIImage imageNamed:@"me_hightlighted.png"]];
    meNav.ng_tabBarItem.titleColor = [UIColor grayColor];
    meNav.ng_tabBarItem.selectedTitleColor = DefaultTabBarTitleHilightedTintColor;
    meNav.ng_tabBarItem.selectedImageTintColor = DefaultTabBarImageHilightedTintColor;
    
    NSArray *vcArray = [NSArray arrayWithObjects:huoNav,baoNav,passportNav,friendNav,meNav,nil];
    
    NGTestTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];
    tabBarController.chatListVC = friendVC;
    
    huoNav.delegate = tabBarController;
    baoNav.delegate = tabBarController;
    passportNav.delegate = tabBarController;
    friendNav.delegate = tabBarController;
    meNav.delegate = tabBarController;
    
    tabBarController.viewControllers = vcArray;
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)initplatform
{

    

    [TestFlight takeOff:@"e3516ed3-5900-4c8d-bc13-ce419d3e0920"];
    [ShareSDK registerApp:@"21678e7340ae"];
    [ShareSDK connectWeChatWithAppId:@"wx86d4bb9d3bf084aa" wechatCls:[WXApi class]];
    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"skKqalClmdZit1sPRE1OuUdE" generalDelegate:self];
	if (!ret) {
		NSLog(@"百度地图启动失败!!!");
	}
    else{
        NSLog(@"百度地图成功启动!!!");
    }
}

-(void)clearTmpfile
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
        if (result) {
            NSLog(@"remove tmp succeed");
        }
        else{
            NSLog(@"remove tmp faild");
        }
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [path objectAtIndex:0];
    childFilesEnumerator = [[manager subpathsAtPath:cachesPath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cachesPath stringByAppendingPathComponent:fileName];
        BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
        if (result) {
            NSLog(@"remove caches succeed");
        }
        else{
            NSLog(@"remove caches faild");
        }
    }
}

-(void)initContactList
{
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"科比",@"栋明",@"乐嘉",@"麦地",@"agan",@"阿甘",@"颖雅",@"a睿智",@"纳什",@"很好ko", nil];
    
    CFIndex nPeople = [array count];
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        addressBook.name = [array objectAtIndex:i];
        addressBook.recordID = nPeople;
        addressBook.rowSelected = NO;
        [addressBookTemp addObject:addressBook];
    }
    
    
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (TKAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (TKAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    HeSysbsModel *sysbsModel = [HeSysbsModel getSysbsModel];

    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        NSMutableArray *mutablesortedSection = [[NSMutableArray alloc] initWithArray:sortedSection];
        
        [sysbsModel.listContent addObject:mutablesortedSection];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(150.f, 60.f);
    } else {
        return CGSizeMake(55.f, 49.f);
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillResignActive:application];

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken{
	// 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"acceptState":@NO, @"isGroup":@NO}];
    [[ApplyViewController shareController] addNewApply:dic];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
    if (!groupId || !username) {
        return;
    }
    
    NSString *groupName = groupId;
    if (!message || message.length == 0) {
        message = [NSString stringWithFormat:@"%@ 邀请你加入群组\'%@\'", username, groupName];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupName, @"id":groupId, @"username":username, @"applyMessage":message, @"acceptState":@NO, @"isGroup":@YES}];
    [[ApplyViewController shareController] addNewApply:dic];
}

/*******点击打开微信******/
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end
