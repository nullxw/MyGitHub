//
//  HeNewFriendListView.m
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeNewFriendListView.h"
#import "AsynImageView.h"

@interface HeNewFriendListView ()
@property(strong,nonatomic)IBOutlet UITableView *friendListTable;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *addfriendList;

@end

@implementation HeNewFriendListView
@synthesize friendListTable;
@synthesize pictureArray = _pictureArray;
@synthesize addfriendList;
@synthesize updateListDelegate;
@synthesize loadSucceedFlag;

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
        label.text = @"新的小伙伴";
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
    
    addfriendList = [[NSMutableArray alloc] initWithCapacity:0];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    addfriendList = sysModel.user.requestFriendList;
    friendListTable.userInteractionEnabled = YES;
}

-(void)initView
{
    [self setExtraCellLineHidden:friendListTable];
}


-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)agreeWithDic:(NSDictionary *)dic
{
    if (dic == nil) {
        [self showTipLabelWith:@"添加失败"];
        return;
    }
    int state = [[dic objectForKey:@"state"] intValue];
    if (state != 1) {
        NSString *msg = [dic objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"添加失败";
        }
        [self showTipLabelWith:msg];
    }
    [self showTipLabelWith:@"添加成功"];
//    NSThread *thread = [[NSThread alloc] initWithTarget:updateListDelegate selector:@selector(updateFriendList) object:nil];
//    [thread start];
    [updateListDelegate updateFriendList];
    [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.1];
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
	[hud hide:YES afterDelay:1.5f];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [addfriendList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *kCustomCellID = @"HeNewFriendCell";
	HeNewFriendCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[HeNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    cell.agreeDelegate = self;
	TKAddressBook *book = (TKAddressBook *)[addfriendList objectAtIndex:row];
    cell.uid = book.fuid;
    
    Dao *shareDao = [Dao sharedDao];
    
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,book.fuuid];
    
	[cell.asyncImage setImageURL:imageUrl];
    cell.titleLabel.text = book.fusername;
    cell.signLabel.text = book.sign;
    if (book.sign == nil) {
        cell.signLabel.text = @"暂无签名";
    }
    
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(void)showLoadLabel:(NSString*)string
{
    MBProgressHUD *HUDTemp = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUDTemp];
    HUDTemp.delegate = self;
    HUDTemp.labelText = string;
    [HUDTemp showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}
-(void)isLoadSucceed
{
    while (self.loadSucceedFlag == 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
