//
//  HeMyHuoBoxView.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeMyHuoBoxView.h"
#import "AsynImageView.h"
#import "HeBaoPiaoDetailView.h"
#import "JSONKit/JSONKit.h"


@interface HeMyHuoBoxView ()
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;
@property(strong,nonatomic)EGORefreshTableHeaderView *refreshHeaderView;
@property(strong,nonatomic)EGORefreshTableFootView *refreshFooterView;
@property(strong,nonatomic)NSMutableArray *huoListArray;

@end

@implementation HeMyHuoBoxView
@synthesize huoBoxTable;
@synthesize pictureArray = _pictureArray;
@synthesize downloadedArray = _downloadedArray;
@synthesize huoListArray;
@synthesize loadSucceedFlag;
@synthesize dateline;
@synthesize refreshFooterView;
@synthesize refreshHeaderView;

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
        label.text = @"活箱";
        [label sizeToFit];
        
        updateOption = 1;
        dateline = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
    [self initView];
    [self loadHuoList];
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
    
    self.pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.downloadedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}


-(void)initView
{
    huoListArray = [[NSMutableArray alloc] initWithCapacity:0];
    huoBoxTable.backgroundView = nil;
    huoBoxTable.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:242.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    huoBoxTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:huoBoxTable];
    
    self.huoBoxTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbg.png"]];
    self.huoBoxTable.backgroundColor = [UIColor clearColor];
    self.huoBoxTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullUpUpdate];
}

-(void)loadHuoList
{
    self.loadSucceedFlag = 0;
    
    [self showLoadLabel:@"加载中..."];
    
    NSLog(@"loadHuolist");
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;
    
    NSString *option = [NSString stringWithFormat:@"%d",updateOption];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:dateline,@"dateline",option,@"option",uid,@"uid", nil];
    [shareDao asyncgetHuo_caseWith:dic];
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
        if (([msg isMemberOfClass:[NSNull class]] || msg == nil) && updateOption == 1) {
            msg = @"加载出错";
        }
        [self showTipLabelWith:msg];
        return;
    }
    
    
    NSArray *tempArray = [receiveDic objectForKey:@"items"];
    if (updateOption == 1 && tempArray != nil && ![tempArray isMemberOfClass:[NSNull class]] && [tempArray count] != 0) {
        [huoListArray removeAllObjects];
        
        if (tempArray != nil && [tempArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *huo in tempArray) {
                [huoListArray addObject:huo];
            }
        }
        
        [huoBoxTable reloadData];
        if ([huoListArray count] >= 3) {
            [self pullDownUpdate];
        }
    }
   
    else{
        if (tempArray != nil && [tempArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *huo in tempArray) {
                [huoListArray addObject:huo];
            }
            [huoBoxTable reloadData];
            if ([huoListArray count] >= 3) {
                [self pullDownUpdate];
            }
        }
        
        
    }
    
    if (updateOption == 1 && ![dateline isEqualToString:@""]) {
        [self showTipLabelWith:@"刷新成功"];
    }
    else{
        [self showTipLabelWith:@"加载成功"];
    }
}

-(void)pullUpUpdate
{
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.huoBoxTable.bounds.size.height, self.view.frame.size.width, self.huoBoxTable.bounds.size.height)];
    refreshHeaderView.delegate = self;
    [huoBoxTable addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
}

-(void)pullDownUpdate
{
    if (refreshFooterView == nil) {
        refreshFooterView = [[EGORefreshTableFootView alloc] init];
    }
    refreshFooterView.frame = CGRectMake(0, huoBoxTable.contentSize.height, 320, 650);
    
    
    refreshFooterView.delegate = self;
    [huoBoxTable addSubview:refreshFooterView];
    [refreshFooterView refreshLastUpdatedDate];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    [self loadHuoList];
    [self updateDataSource];
}

-(void)updateDataSource
{
    NSLog(@"reloading data source");
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];//视图的数据下载完毕之后，开始刷新数据
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    _reloading = NO;
    switch (updateOption) {
        case 1:
            [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:huoBoxTable];
            break;
        case 2:
            [refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:huoBoxTable];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //刚开始拖拽的时候触发下载数据
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}

/*******************Foot*********************/
#pragma mark -
#pragma mark EGORefreshTableFootDelegate Methods
- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view
{
    updateOption = 2;//加载历史标志
    @try {
        NSDictionary *tepDic = [huoListArray objectAtIndex:[huoListArray count] - 1];
        self.dateline = [tepDic objectForKey:@"dateline"];
    }
    @catch (NSException *exception) {
        //抛出异常不应当处理dateline
        NSLog(@"exception is : %@",exception);
    }
    @finally {
        if (dateline == nil || [dateline isMemberOfClass:[NSNull class]]) {
            dateline = @"";
        }
        [self reloadTableViewDataSource];//触发刷新，开始下载数据
    }
}
- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}
- (NSDate*)egoRefreshTableFootDataSourceLastUpdated:(EGORefreshTableFootView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

/*******************Header*********************/
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    updateOption = 1;//刷新加载标志
    @try {
        NSDictionary *tepDic = [huoListArray objectAtIndex:0];
        self.dateline = [tepDic objectForKey:@"dateline"];
    }
    @catch (NSException *exception) {
        //抛出异常不应当处理dateline
        NSLog(@"exception is : %@",exception);
    }
    @finally {
        if (dateline == nil || [dateline isMemberOfClass:[NSNull class]]) {
            dateline = @"";
        }
        [self reloadTableViewDataSource];//触发刷新，开始下载数据
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [huoListArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"HeMyHuoBoxCell";
    HeMyHuoBoxCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        
        cell = [[HeMyHuoBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSDictionary *dic = [huoListArray objectAtIndex:row];
    NSString *name = [dic objectForKey:@"name"];
    if (name == nil || [name isMemberOfClass:[NSNull class]]) {
        name = @"2014秦皇岛海洋演唱会";
    }
    cell.titleLabel.text = name;
    
    NSString *address = [dic objectForKey:@"address"];
    if (address == nil || [address isMemberOfClass:[NSNull class]]) {
        address = @"2014秦皇岛海洋演唱会";
    }
    cell.addressLabel.text = address;
    
    NSString *endtime = [dic objectForKey:@"endtime"];
    if (endtime == nil || [endtime isMemberOfClass:[NSNull class]]) {
        endtime = @"";
    }
    NSString *starttime = [dic objectForKey:@"starttime"];
    if (starttime == nil || [starttime isMemberOfClass:[NSNull class]]) {
        starttime = @"";
    }
    if ([starttime length] >= 10) {
        starttime = [starttime substringToIndex:10];
    }
    if ([endtime length] >= 10) {
        endtime = [endtime substringToIndex:10];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@/%@",starttime,endtime];
    cell.timeLabel.text = timeStr;
    
    NSString *creditrequirements = [dic objectForKey:@"creditrequirements"];
    if (creditrequirements == nil || [creditrequirements isMemberOfClass:[NSNull class]]) {
        creditrequirements = @"";
    }
    cell.numberLabel.text = creditrequirements;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeBaoPiaoDetailView *baoPiaoView = [[HeBaoPiaoDetailView alloc] initWitgTypeID:2];
    baoPiaoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baoPiaoView animated:YES];
}

//判断图片是否已经下载
-(BOOL)picLoaded:(NSString*)url
{
    NSInteger num = [_downloadedArray count];
    for (int i = 0; i < num; i++) {
        NSString *temp = [_downloadedArray objectAtIndex:i];
        if ([temp isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

-(int)findAsyImage:(NSString*)string
{
    @try {
        NSInteger num = [_downloadedArray count];
        for (int i = 0; i< num; i++) {
            NSString *loadString = [_downloadedArray objectAtIndex:i];
            if ([string isEqualToString:loadString]) {
                return i;
                break;
            }
        }
        return -1;
    }
    @catch (NSException *exception) {
        return -1;
    }
    @finally {
        
    }
    
}

-(void)tapGes:(UITapGestureRecognizer *)tap
{
    AsynImageView *image = (AsynImageView *)tap.view;
    image.highlighted = YES;
    [self performSelector:@selector(baoPiaoDetail:) withObject:image afterDelay:0.5];
}

-(void)baoPiaoDetail:(AsynImageView *)image
{
    image.highlighted = NO;
    HeBaoPiaoDetailView *baoPiaoView = [[HeBaoPiaoDetailView alloc] init];
    baoPiaoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baoPiaoView animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
