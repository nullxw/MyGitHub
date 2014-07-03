//
//  TKContactsMultiPickerController.m
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "HeFriendViewController.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"
#import "HeSysbsModel.h"
#import "HeNewFriendListView.h"
#import "HeFriendDetailView.h"
#import "HeGiveTicketView.h"
#import "HeAddFriendView.h"
#import "Dao+syncFriendCategory.h"

@interface HeFriendViewController(PrivateMethod)



@end

@implementation HeFriendViewController
@synthesize downloadedArray = _downloadedArray;
@synthesize pictureArray = _pictureArray;
@synthesize tableView = _tableView;
@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize savedScopeButtonIndex = _savedScopeButtonIndex;
@synthesize searchWasActive = _searchWasActive;
@synthesize searchBar = _searchBar;
@synthesize timer;
@synthesize line;
@synthesize listContent = _listContent;
@synthesize currentIndexpath;
@synthesize headerRefreshView;
@synthesize loadSucceedFlag;

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedCount = 0;
        _listContent = [NSMutableArray new];
        _filteredListContent = [NSMutableArray new];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"小伙伴";
        [label sizeToFit];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateFriendList) name:@"loginSucceed" object:nil];
    [self initControl];
    
    [self initContactList];

}

-(void)initContactList
{
    HeSysbsModel *sysbsModel = [HeSysbsModel getSysbsModel];
    _listContent = sysbsModel.listContent;
    if ([_listContent count] == 0) {
        [self downloadMyFriendList];
    }
}
//加载小伙伴列表
-(void)downloadMyFriendList
{
    
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if (sysModel.user.stateID != 1) {
        return;
    }
    self.loadSucceedFlag = 0;
    [self showLoadLabel:@"加载中..."];
    
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid", nil];
    
    [shareDao asyncRequestFriendListWith:dic];
    
//    [shareDao requestFriendListWith:dic];

}

-(void)requestSucceedWithDic:(NSDictionary *)receiveDic
{
    self.loadSucceedFlag = 1;
    HeSysbsModel *sysbsModel = [HeSysbsModel getSysbsModel];
    _listContent = sysbsModel.listContent;
    if ([sysbsModel.user.requestFriendList count] > 0) {
        offset = 1;
    }
    else{
        offset = 0;
    }
    [_tableView reloadData];
    [headerRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

-(void)initControl
{
    headerRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
    headerRefreshView.delegate = self;
    [self.tableView addSubview:headerRefreshView];
    [headerRefreshView refreshLastUpdatedDate];
    
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    offset = 0;
    if ([sysModel.user.requestFriendList count] > 0) {
        offset = 1;
    }
    
    self.tableView.sectionHeaderHeight = 40.0f;
    self.searchBar.tintColor = [UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    if (sysModel.user.stateID == 1) {
        UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add.png"]];
        addImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 40, (self.navigationController.navigationBar.frame.size.height - 35)/2, 35, 35);
        addImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)];
        [addImage addGestureRecognizer:addTap];
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:addImage];
        [leftBarItem setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [leftBarItem setBackgroundImage:[UIImage imageNamed:@"add_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [leftBarItem setTarget:self];
        [leftBarItem setAction:@selector(addFriend:)];
        
        leftBarItem.tag = 2;
        addImage.tag = 2;
        self.navigationItem.rightBarButtonItem = leftBarItem;
    }
    
    
    self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
	self.searchDisplayController.searchBar.showsCancelButton = NO;
    
    
    
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:_savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
    
    
    _downloadedArray = [[NSMutableArray alloc] initWithCapacity:0];
    _pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [self.tableView setEditing:NO animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadMyFriendList) object:nil];
    [thread start];
    [self updateDataSource];
}



-(void)updateDataSource
{
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];//视图的数据下载完毕之后，开始刷新数据
}
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    _reloading = NO;
    [headerRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //刚开始拖拽的时候触发下载数据
	[headerRefreshView egoRefreshScrollViewDidScroll:scrollView];
   
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [headerRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
   
}


/*******************Header*********************/
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];//触发刷新，开始下载数据
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

-(void)searchButtonAction:(id)sender
{
    
}

-(void)addFriend:(id)sender
{
    //扫描二维码
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.cameraMode = ZBarReaderControllerCameraModeSampling;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.wantsFullScreenLayout = YES;
    reader.showsZBarControls = NO;
    CGRect scanFrame = CGRectMake(40.0, 120.0, 200.0, 200.0);
    CGFloat y = 1-(scanFrame.origin.x+scanFrame.size.width)/reader.view.bounds.size.width;
    CGFloat height = 1-scanFrame.origin.x/reader.view.bounds.size.width;
    CGRect scanCrop = CGRectMake(0.1, y, 0.6, height);
    reader.scanCrop = scanCrop;
    reader.view.frame = [[UIScreen mainScreen] bounds];
    //设置自己定义的界面
    
    [self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    //    reader.readerDelegate = self;
    [self presentViewController:reader animated:YES completion:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(move:) userInfo:nil repeats:YES];
    [timer fire];
}




-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)move:(id)sender
{
    float y = self.line.frame.origin.y;
    if (y < 320)
    {
        self.line.frame = CGRectMake(60, y+3, 200, 2);
    }
    else
    {
        self.line.frame = CGRectMake(60, 120, 200, 2);
    }
    
}

-(void)getFriendInfoWith:(NSString *)uuid
{
    Dao *shareDao = [Dao sharedDao];
    //获取状态ID
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    NSString *myid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"uuid",@"t",uuid,@"value",myid,@"myid", nil];
    
    NSDictionary *dict = [shareDao getFriendInfo:dic];
    
    
    
    int stateid = [[dict objectForKey:@"state"] intValue];
    NSString *errorString = nil;
    if (stateid == -1) {
        errorString = [dict objectForKey:@"msg"];
        if ([errorString isMemberOfClass:[NSNull class]]) {
            errorString = @"";
        }
        [self showTipLabelWith:errorString];
        return;
    }
    NSDictionary *userDic = [dict objectForKey:@"userinfo"];
    
    NSString *userfriendship = [dict objectForKey:@"userfriendship"];
    if (userfriendship == nil || [userfriendship isMemberOfClass:[NSNull class]]) {
        userfriendship = @"";
    }
    int isfriend = [userfriendship intValue];
    if (isfriend == 1) {
        HeFriendDetailView *friendDetail = [[HeFriendDetailView alloc] initWithDict:userDic];
        friendDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
    else{
        HeAddFriendView *friendDetail = [[HeAddFriendView alloc] initWithDict:userDic];
        friendDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
    
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [self.timer invalidate];
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    UIImage *image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    [reader dismissViewControllerAnimated:YES completion:nil];
    NSString *scanStr =  symbol.data;
    id scanObject = [scanStr objectFromJSONString];
    if (![scanObject isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该二维码非活宝小伙伴二维码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *dict = [scanStr objectFromJSONString];
    NSString *uuid = [dict objectForKey:@"uuid"];
    if (uuid == nil || [uuid isMemberOfClass:[NSNull class]]) {
        uuid = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该二维码非活宝小伙伴二维码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(getFriendInfoWith:) object:uuid];
//    [thread start];
    [self performSelector:@selector(getFriendInfoWith:) withObject:uuid afterDelay:0.5];
    
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader

{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanline.png"]];
    line.frame = CGRectMake(40, 120, 260, 5);
    //    [[UIImageView alloc] initWithFrame:CGRectMake(60, 120, 200, 2)];
    //    line.backgroundColor = [UIColor redColor];
    [reader.view addSubview:line];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    
    
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头20CM左右，系统会自动识别。";
    [upView addSubview:labIntroudction];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 60, 200)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(260, 120, 60, 200)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    
    
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, [[UIScreen mainScreen] bounds].size.height - 320)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    
    UIImageView *rightupIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightup.png"]];
    rightupIcon.frame = CGRectMake(250.0, 110.0, 20.0, 20.0);
    [reader.view addSubview:rightupIcon];
    
    UIImageView *leftupIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftup.png"]];
    leftupIcon.frame = CGRectMake(50.0, 110.0, 20.0, 20.0);
    [reader.view addSubview:leftupIcon];
    
    UIImageView *leftdownIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftdown.png"]];
    leftdownIcon.frame = CGRectMake(50.0, 310.0, 20.0, 20.0);
    [reader.view addSubview:leftdownIcon];
    UIImageView *rightdownIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightdown.png"]];
    rightdownIcon.frame = CGRectMake(250.0, 310.0, 20.0, 20.0);
    [reader.view addSubview:rightdownIcon];
    
    //用于取消操作的button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton warningStyle];
    cancelButton.alpha = 0.9;
    [cancelButton setFrame:CGRectMake(60,380 , 200, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
}

//取消button方法

- (void)dismissOverlayView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)checkButtonClick:(id)sender
{
    HeNewFriendListView *friendlist = [[HeNewFriendListView alloc] init];
    friendlist.updateListDelegate = self;
    friendlist.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendlist animated:YES];
}

-(void)updateFriendList
{
    
    Dao *shareDao = [Dao sharedDao];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if (sysModel.user.stateID != 1) {
        self.navigationItem.rightBarButtonItem = nil;
        sysModel.listContent = nil;
        self.listContent = nil;
        sysModel.user.requestFriendList = nil;
        [_tableView reloadData];
        return;
    }
    
    UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add.png"]];
    addImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 40, (self.navigationController.navigationBar.frame.size.height - 35)/2, 35, 35);
    addImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)];
    [addImage addGestureRecognizer:addTap];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:addImage];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"add_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [leftBarItem setTarget:self];
    [leftBarItem setAction:@selector(addFriend:)];
    
    leftBarItem.tag = 2;
    addImage.tag = 2;
    
    self.navigationItem.rightBarButtonItem = leftBarItem;
    
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid", nil];
    [shareDao requestFriendListWith:dic];
    self.loadSucceedFlag = 1;
    HeSysbsModel *sysbsModel = [HeSysbsModel getSysbsModel];
    _listContent = sysbsModel.listContent;
    if ([sysModel.user.requestFriendList count] > 0) {
        offset = 1;
    }
    else{
        offset = 0;
    }
    [_tableView reloadData];
    [headerRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self showTipLabelWith:@"添加成功"];
}

-(void)longtapGes:(HeMylongpress *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        currentIndexpath = [tap.myDict objectForKey:@"indexPath"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"赠送门票",@"删除小伙伴", nil];
        [alert show];
    }
    
}

-(void)deleteFriend
{
    NSInteger row = currentIndexpath.row;
    NSInteger section = currentIndexpath.section;
   
    TKAddressBook *addressBook = (TKAddressBook *)[[_listContent objectAtIndex:section - offset] objectAtIndex:row];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSString *fuid = addressBook.fuid;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid",fuid,@"fuid", nil];
    
    Dao *shareDao = [Dao sharedDao];
    NSDictionary *dic = [shareDao deleteFriendWithDict:dict];
    NSLog(@"dic = %@",dic);
    
    NSString *stateStr = [dic objectForKey:@"state"];
    if ([stateStr intValue] != 1) {
        NSString *msg = [dic objectForKey:@"msg"];
        if ([msg isMemberOfClass:[NSNull class]] || msg == nil) {
            msg = @"删除失败";
        }
        [self showTipLabelWith:msg];
        return;
    }
    [[_listContent objectAtIndex:section - offset] removeObjectAtIndex:row];
//    [[sysModel.listContent objectAtIndex:section - offset] removeObjectAtIndex:row];
    
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexpath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    self.tableView.scrollsToTop = YES;
    [self.tableView scrollsToTop];
    [self showTipLabelWith:@"删除成功"];
    sysModel.listContent = _listContent;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            break;
        }
        case 1:
        {
            NSInteger row = currentIndexpath.row;
            NSInteger section = currentIndexpath.section;
            NSArray *array = [[NSArray alloc] initWithObjects:[[_listContent objectAtIndex:section - offset] objectAtIndex:row], nil];
            HeGiveTicketV *giveTicket = [[HeGiveTicketV alloc] initWithArray:array];
            giveTicket.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:giveTicket animated:YES];
            break;
        }
        case 2:
        {
            [self deleteFriend];
            break;
        }
        default:
            break;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (offset == 1 && indexPath.section == 0) {
            return;
        }
        currentIndexpath = indexPath;
        [self deleteFriend];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        NSArray *array = [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                                 [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
        
        return array;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index - offset];
            
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [_listContent count] + offset;
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
      
        if (offset > 0 && section == 0) {
            return @"#";
        }
        NSArray *array = (NSArray *)[self.listContent objectAtIndex:section];
        NSInteger nums = [array count];
        return nums ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        
        if (offset > 0 && section == 0) {
            return nil;
            
        }
        NSArray *array = (NSArray *)[self.listContent objectAtIndex:section - offset];
        NSInteger nums = [array count];
        NSString *str =  nums ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section - offset] : nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        label.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"    %@",str];
        [label sizeToFit];
        
        return label;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    if (offset > 0 && section == 0) {
        return 0;
        
    }
    return [((NSArray *)[_listContent objectAtIndex:section - offset]) count] ? tableView.sectionHeaderHeight : 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredListContent count];
    } else {
        if (offset > 0 && section == 0) {
            return 1;
            
        }
        NSInteger rows = (NSInteger)[((NSArray *)[_listContent objectAtIndex:section - offset]) count];
        return rows;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
   
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if (tableView != self.searchDisplayController.searchResultsTableView && section == 0 && offset == 1) {
        static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
        UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
        }
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        cell.textLabel.text = [NSString stringWithFormat:@"有%d个新的小伙伴邀请",[sysModel.user.requestFriendList count]];
        cell.backgroundColor = [UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
        
        UIButton *checkButton = [[UIButton alloc] init];
        [checkButton setTitle:@"查看" forState:UIControlStateNormal];
        checkButton.frame = CGRectMake(220.0, 10.0, 60.0, 30.0);
        [checkButton successStyle];
        [checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:checkButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
	static NSString *heFriendViewCell = @"HeFriendViewCell";
	HeFriendViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:heFriendViewCell];
	if (!cell)
	{
		cell = [[HeFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:heFriendViewCell];
        cell.userInteractionEnabled = YES;
        
	}
    
    HeMylongpress *longtap = [[HeMylongpress alloc] init];
    longtap.minimumPressDuration = 0.8;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:indexPath,@"indexPath", nil];
    [longtap setMyDict:dic];
    [longtap addTarget:self action:@selector(longtapGes:)];
    [cell addGestureRecognizer:longtap];
    
	TKAddressBook *addressBook = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (TKAddressBook *)[_filteredListContent objectAtIndex:indexPath.row];
	else
        addressBook = (TKAddressBook *)[[_listContent objectAtIndex:indexPath.section - offset] objectAtIndex:indexPath.row];
    if ([[addressBook.fusername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.nameLabel.text = addressBook.fusername;
        
    } else {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.nameLabel.text = @"匿名";
    }
    Dao *shareDao = [Dao sharedDao];
    
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,addressBook.fuuid];
    
	cell.asyncImage.imageURL = imageUrl;
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    
    if (tableView != self.searchDisplayController.searchResultsTableView && indexPath.section == 0 && offset == 1) {
        return 50.0f;
    }
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		[self tableView:self.searchDisplayController.searchResultsTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
		[self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        if (indexPath.section == 0 && offset == 1) {
            return;
        }
        
	}
    TKAddressBook *book = [[_listContent objectAtIndex:section - offset] objectAtIndex:row];
    HeFriendDetailView *friendDetailView = [[HeFriendDetailView alloc] initWithuuid:book.fuuid];
    friendDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendDetailView animated:YES];
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.searchDisplayController.searchResultsTableView && indexPath.section == 0) {
        return;
    }
	TKAddressBook *addressBook = nil;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
		addressBook = (TKAddressBook*)[_filteredListContent objectAtIndex:indexPath.row];
	else
        addressBook = (TKAddressBook*)[[_listContent objectAtIndex:indexPath.section - offset] objectAtIndex:indexPath.row];
    
    BOOL checked = !addressBook.rowSelected;
    addressBook.rowSelected = checked;
    
    // Enabled rightButtonItem
    if (checked) _selectedCount++;
    else _selectedCount--;
    [self.navigationItem.rightBarButtonItem setEnabled:(_selectedCount > 0 ? YES : NO)];
    
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    [button setSelected:checked];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	
	if (indexPath != nil)
	{
		[self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark Save action

-(void)commitAction:(id)sender
{
	NSMutableArray *objects = [NSMutableArray new];
    for (NSArray *section in _listContent) {
        for (TKAddressBook *addressBook in section)
        {
            if (addressBook.rowSelected)
                [objects addObject:addressBook];
        }
    }
    
    NSLog(@"%@",objects);
    [self giveTicketWithArray:objects];
	
}

-(void)giveTicketWithArray:(NSArray *)array
{
    HeGiveTicketV *giveTicketView = [[HeGiveTicketV alloc] initWithArray:array];
    giveTicketView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giveTicketView animated:YES];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredListContent removeAllObjects];
    for (NSMutableArray *section in _listContent) {
        for (TKAddressBook *addressBook in section)
        {
            NSComparisonResult result = [addressBook.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:addressBook];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

-(void)showLoadLabel:(NSString*)string
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = string;
    [HUD showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}

-(void)isLoadSucceed
{
    while (self.loadSucceedFlag == 0);
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSucceed" object:nil];
}


@end