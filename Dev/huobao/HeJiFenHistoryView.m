//
//  HeJiFenHistoryView.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeJiFenHistoryView.h"

@interface HeJiFenHistoryView ()
@property(strong,nonatomic)EGORefreshTableHeaderView *refreshHeaderView;
@property(strong,nonatomic)EGORefreshTableFootView *refreshFooterView;

@end

@implementation HeJiFenHistoryView
@synthesize jifenTable;
@synthesize loadSucceedFlag;
@synthesize dateline;
@synthesize refreshFooterView;
@synthesize refreshHeaderView;
@synthesize jifenHistoryArray;

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
        label.text = @"积分历史";
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
    [self loadJifenList];
}

-(void)initControl
{
    jifenHistoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    dateline = @"";
    updateOption = 1;
    
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
    self.jifenTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbg.png"]];
    self.jifenTable.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:jifenTable];
//    self.jifenTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullUpUpdate];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pullUpUpdate
{
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.jifenTable.bounds.size.height, self.view.frame.size.width, self.jifenTable.bounds.size.height)];
    refreshHeaderView.delegate = self;
    [jifenTable addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
}

-(void)pullDownUpdate
{
    if (refreshFooterView == nil) {
        refreshFooterView = [[EGORefreshTableFootView alloc] init];
    }
    refreshFooterView.frame = CGRectMake(0, jifenTable.contentSize.height, 320, 650);
    
    
    refreshFooterView.delegate = self;
    [jifenTable addSubview:refreshFooterView];
    [refreshFooterView refreshLastUpdatedDate];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    [self loadJifenList];
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
            [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:jifenTable];
            break;
        case 2:
            [refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:jifenTable];
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
        NSDictionary *tepDic = [jifenHistoryArray objectAtIndex:[jifenHistoryArray count] - 1];
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
        NSDictionary *tepDic = [jifenHistoryArray objectAtIndex:0];
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

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)loadJifenList
{
    self.loadSucceedFlag = 0;
    
    [self showLoadLabel:@"加载中..."];
    
    NSLog(@"loadHuolist");
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;
    HeSysbsModel *model = [HeSysbsModel getSysbsModel];
    
    NSString *option = [NSString stringWithFormat:@"%d",updateOption];
    NSString *uid = [NSString stringWithFormat:@"%d",model.user.uid];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:dateline,@"dateline",option,@"option",uid,@"uid", nil];
    [shareDao asyncgetCreditHistoryWith:dic];
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
        if (([msg isMemberOfClass:[NSNull class]] || msg == nil) && updateOption == 1) {
            msg = @"加载出错";
        }
        [self showTipLabelWith:msg];
        return;
    }
    
    NSArray *tempArray = [receiveDic objectForKey:@"items"];
    if (updateOption == 1 && tempArray != nil && ![tempArray isMemberOfClass:[NSNull class]] && [tempArray count] != 0) {
        [jifenHistoryArray removeAllObjects];
        
        if (tempArray != nil && [tempArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *huo in tempArray) {
                [jifenHistoryArray addObject:huo];
            }
        }
        
        [jifenTable reloadData];
        if ([jifenHistoryArray count] >= 9) {
            [self pullDownUpdate];
        }
    }
    if (updateOption == 1 && ![dateline isEqualToString:@""]) {
        [self showTipLabelWith:@"刷新成功"];
    }
    else{
        [self showTipLabelWith:@"加载成功"];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jifenHistoryArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"HeJiFenHistoryCell";
	HeJiFenHistoryCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[HeJiFenHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    NSInteger row = indexPath.row;
    NSDictionary *dic = [jifenHistoryArray objectAtIndex:row];
    NSLog(@"dic = %@",dic);
    NSString *nameStr = [dic objectForKey:@"operation"];
    if (nameStr == nil || [nameStr isMemberOfClass:[NSNull class]]) {
        nameStr = @"匿名活动";
    }
    
    NSString *datelineStr = [dic objectForKey:@"dateline"];
    if (datelineStr == nil || [datelineStr isMemberOfClass:[NSNull class]]) {
        datelineStr = @"0";
    }
    NSInteger interval = [datelineStr intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *timeString = [self stringFromDate:confromTimesp];
//    int creditrequirements = [[dic objectForKey:@"creditrequirements"] intValue];
//    if (creditrequirements < 0) {
//        int credit = -creditrequirements;
//        
//        cell.titleLabel.text = [NSString stringWithFormat:@"参加%@消耗%d积分",nameStr,credit];
//    }
//    else{
//        cell.titleLabel.text = [NSString stringWithFormat:@"参加%@获取%d积分",nameStr,creditrequirements];
//    }
    cell.titleLabel.text = nameStr;
    cell.timeLabel.text = timeString;
	
	return cell;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
