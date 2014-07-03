//
//  HeHuoViewController.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeBaoViewController.h"
#import "HeSearchHuoView.h"
#import "HeQRCodeView.h"
#import "HeSearchHuoView.h"
#import "HeActivityDetailView.h"

@interface HeBaoViewController ()
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UIImageView *line;
@property(strong,nonatomic)IBOutlet UITableView *huotable;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;
@property(strong,nonatomic)EGORefreshTableHeaderView *refreshHeaderView;
@property(strong,nonatomic)EGORefreshTableFootView *refreshFooterView;
@property(strong,nonatomic)NSMutableArray *huoListArray;

@end

@implementation HeBaoViewController
@synthesize timer;
@synthesize line;
@synthesize huotable;
@synthesize pictureArray = _pictureArray;
@synthesize downloadedArray = _downloadedArray;
@synthesize refreshFooterView;
@synthesize refreshHeaderView;
@synthesize huoListArray;
@synthesize loadSucceedFlag;
@synthesize dateline;

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
        label.text = @"宝";
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


-(void)requestSucceedWithStateID:(int)stateid withErrorStirng:(NSString *)errorString
{
    self.loadSucceedFlag = 1;
    if (stateid != 1) {
        [self showTipLabelWith:errorString];
    }
    
}

-(void)initControl
{
    huoListArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIImageView *qrscanImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrscanItem.png"]];
    qrscanImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 40, (self.navigationController.navigationBar.frame.size.height - 35)/2, 35, 35);
    qrscanImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *qrscanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonAction:)];
    qrscanTap.numberOfTapsRequired = 1;
    qrscanTap.numberOfTouchesRequired = 1;
    [qrscanImage addGestureRecognizer:qrscanTap];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:qrscanImage];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"qrscanItem.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"qrscanItem_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [leftBarItem setTarget:self];
    leftBarItem.tag = 1;
    qrscanImage.tag = 1;
    [leftBarItem setAction:@selector(barButtonAction:)];
    self.navigationItem.rightBarButtonItem = leftBarItem;
    
    UIImageView *searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchItem.png"]];
    searchImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 40, (self.navigationController.navigationBar.frame.size.height - 35)/2, 35, 35);
    searchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonAction:)];
    searchTap.numberOfTapsRequired = 1;
    searchTap.numberOfTouchesRequired = 1;
    [searchImage addGestureRecognizer:searchTap];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchImage];
    [rightBarItem setBackgroundImage:[UIImage imageNamed:@"searchItem.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [rightBarItem setBackgroundImage:[UIImage imageNamed:@"searchItem_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [rightBarItem setTarget:self];
    rightBarItem.tag = 2;
    searchImage.tag = 2;
    [rightBarItem setAction:@selector(barButtonAction:)];
    
    self.pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.downloadedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}

-(void)initView
{
    self.huotable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbg.png"]];
    self.huotable.backgroundColor = [UIColor clearColor];
    self.huotable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullUpUpdate];
}

-(void)pullUpUpdate
{
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.huotable.bounds.size.height, self.view.frame.size.width, self.huotable.bounds.size.height)];
    refreshHeaderView.delegate = self;
    [huotable addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
}

-(void)pullDownUpdate
{
    if (refreshFooterView == nil) {
        refreshFooterView = [[EGORefreshTableFootView alloc] init];
    }
    refreshFooterView.frame = CGRectMake(0, huotable.contentSize.height, 320, 650);
    
    
    refreshFooterView.delegate = self;
    [huotable addSubview:refreshFooterView];
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
            [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:huotable];
            break;
        case 2:
            [refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:huotable];
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

-(void)loadHuoList
{
    self.loadSucceedFlag = 0;
    
    [self showLoadLabel:@"加载中..."];
    
    NSLog(@"loadHuolist");
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;
    
    NSString *option = [NSString stringWithFormat:@"%d",updateOption];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:dateline,@"dateline",option,@"option", nil];
    [shareDao asyncBaoListWith:dic];
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
        
        [huotable reloadData];
        if ([huoListArray count] >= 3) {
            [self pullDownUpdate];
        }
    }
    else{
        if (tempArray != nil && [tempArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *huo in tempArray) {
                [huoListArray addObject:huo];
            }
            [huotable reloadData];
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

-(void)barButtonAction:(id)sender
{
    UIImageView *imageView = (UIImageView *)(((UITapGestureRecognizer*)sender).view);
    switch (imageView.tag) {
        case 1:
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
            [self presentViewController:reader animated:YES completion:nil];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(move:) userInfo:nil repeats:YES];
            [timer fire];
            break;
        }
        case 2:
        {
            //搜索
            HeSearchHuoView *searchHuoView = [[HeSearchHuoView alloc] init];
            searchHuoView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchHuoView animated:YES];
            break;
        }
        default:
            break;
    }
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
    NSString *str =  symbol.data ;
    
    HeActivityDetailView *activityDetail = [[HeActivityDetailView alloc] init];
    activityDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityDetail animated:YES];
    
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
    static NSString *cellIndentifier = @"HeHuoTableViewCell";
    HeHuoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[HeHuoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSDictionary *huoTemp = [huoListArray objectAtIndex:row];
    NSString *original = [huoTemp objectForKey:@"cover"];
    NSString *app = [original stringByReplacingOccurrencesOfString:@"original" withString:@"app"];
    
    if (app == nil || [app isMemberOfClass:[NSNull class]]) {
        app = nil;
    }
    Dao *shareDao = [Dao sharedDao];
    cell.asyncImage.imageURL = [NSString stringWithFormat:@"%@/%@",shareDao.imageBaseUrl,app];
    
    NSString *nameStr = [huoTemp objectForKey:@"name"];
    if (nameStr == nil || [nameStr isMemberOfClass:[NSNull class]]) {
        nameStr = @"";
    }
    cell.titleLabel.text = nameStr;
    
    NSString *endtime = [huoTemp objectForKey:@"endtime"];
    if (endtime == nil || [endtime isMemberOfClass:[NSNull class]]) {
        endtime = @"";
    }
    NSString *starttime = [huoTemp objectForKey:@"starttime"];
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
    
    NSString *address = [huoTemp objectForKey:@"address"];
    
    
    
    if (address == nil || [address isMemberOfClass:[NSNull class]]) {
        address = @"";
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[address dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSString *content = attributedString.string;
    
    cell.addressLabel.text = content;
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    CGFloat scale = 2.0f;
    
    CGFloat imageW = [[UIScreen mainScreen] bounds].size.width - 20;
    CGFloat imageH = imageW/scale;
    CGFloat bgH = imageH + 100;
    
    return bgH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDic = [huoListArray objectAtIndex:indexPath.row];
    HeActivityDetailView *activityDetailView = [[HeActivityDetailView alloc] initWithActivityDict:tempDic];
    activityDetailView.type = 2;
    activityDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityDetailView animated:YES];
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
