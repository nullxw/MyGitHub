//
//  HeGiveTicketView.m
//  huobao
//
//  Created by Tony He on 14-5-16.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeGiveTicketV.h"
#import "AsynImageView.h"
#import "MBProgressHUD.h"

@interface HeGiveTicketV ()
@property(strong,nonatomic)IBOutlet UITableView *giveTicketTable;
@property(strong,nonatomic)NSMutableArray *giveTicketListArray;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;

@end

@implementation HeGiveTicketV
@synthesize giveTicketTable;
@synthesize giveTicketListArray;
@synthesize pictureArray = _pictureArray;
@synthesize downloadedArray = _downloadedArray;

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
        label.text = @"送票";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.giveTicketListArray = [[NSMutableArray alloc] initWithArray:array];
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
    
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc] init];
    commitButton.title = @"确定";
    [commitButton setTintColor:[UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0f]];
    commitButton.target = self;
    commitButton.action = @selector(commitAction:);
    [self.navigationItem setRightBarButtonItem:commitButton];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView
{
//    self.giveTicketTable.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self setExtraCellLineHidden:giveTicketTable];
}

-(void)commitAction:(id)sender
{
    [self showTipLabelWith:@"送票成功"];
    [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
}

-(void)releaseButtonClick:(UIButton *)sender
{
    TKAddressBook *book = [giveTicketListArray objectAtIndex:sender.tag];
    int num = book.sectionNumber;
    if (num == 0) {
        return;
    }
    else{
        num -- ;
    }
    book.sectionNumber = num;
    [giveTicketTable reloadData];
}

-(void)addButtonClick:(UIButton *)sender
{
    TKAddressBook *book = [giveTicketListArray objectAtIndex:sender.tag];
    int num = book.sectionNumber;
    num++;
    book.sectionNumber = num;
    [giveTicketTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [giveTicketListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
	HeGiveTicketCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[HeGiveTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger row = indexPath.row;
        TKAddressBook *addressBook = [giveTicketListArray objectAtIndex:row];
        
        HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
        Dao *shareDao = [Dao sharedDao];
        
        NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,addressBook.fuuid];
        [cell.asyncImage setImageURL:imageUrl];
        NSString *nameStr = addressBook.name;
        if ([nameStr isMemberOfClass:[NSNull class]] || nameStr == nil) {
            nameStr = @"小伙伴23号";
        }
        cell.nameLabel.text = nameStr;
        
        int num = addressBook.sectionNumber;
        cell.numberLabel.text = [NSString stringWithFormat:@"X %d",num];
    
	}
	
	
    
    
    
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
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

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
