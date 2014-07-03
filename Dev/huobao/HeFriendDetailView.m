//
//  HeFriendDetailView.m
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeFriendDetailView.h"
#import "AsynImageView.h"
#import "HeGiveTicketV.h"
#import "Dao+syncFriendCategory.h"

@interface HeFriendDetailView ()
@property(strong,nonatomic)TKAddressBook *friendBook;
@property(strong,nonatomic)IBOutlet AsynImageView *userImage;
@property(strong,nonatomic)IBOutlet UIImageView *sexImage;
@property(strong,nonatomic)IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UILabel *signLabel;
@property(strong,nonatomic)IBOutlet UIButton *sendButton;
@property(strong,nonatomic)IBOutlet UIButton *giveButton;

-(IBAction)sendMessage:(id)sender;
-(IBAction)giveTicket:(id)sender;

@end

@implementation HeFriendDetailView
@synthesize friendBook;
@synthesize userImage;
@synthesize sexImage;
@synthesize nameLabel;
@synthesize signLabel;
@synthesize sendButton;
@synthesize giveButton;
@synthesize uuid;
@synthesize userDic;

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
        label.text = @"详细信息";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        userDic = [[NSDictionary alloc] initWithDictionary:dic];
        NSString *sexStr = [userDic objectForKey:@"sex"];
        if (sexStr == nil || [sexStr isMemberOfClass:[NSNull class]]) {
            sexStr = @"";
        }
        int sex = [sexStr intValue];
        if (sex != 1) {
            sex = 2;
        }
        
        
        NSString *nichen = [userDic objectForKey:@"nickname"];
        if (nichen == nil || [nichen isMemberOfClass:[NSNull class]]) {
            nichen = @"匿名";
        }
        
        
        NSString *sign = [userDic objectForKey:@"signature"];
        if (sign == nil || [sign isMemberOfClass:[NSNull class]]) {
            sign = @"暂无签名";
        }
        NSString *fuuid = [userDic objectForKey:@"uuid"];
        if (fuuid == nil || [fuuid isMemberOfClass:[NSNull class]]) {
            fuuid = @"";
        }
        
        friendBook = [[TKAddressBook alloc] init];
        friendBook.fusername = nichen;
        friendBook.fuuid = fuuid;
        uuid = fuuid;
        friendBook.name = nichen;
        friendBook.sign = sign;
        friendBook.sex = sex;
        
    }
    return self;
}
-(id)initWithuuid:(NSString *)_uuid
{
    if (self = [super init]) {
        
        friendBook = nil;
        uuid = [[NSString alloc] initWithString:_uuid];
    }
    return self;
}

-(id)initWithBook:(TKAddressBook *)book
{
    if (self = [super init]) {
        
        friendBook.sectionNumber = book.sectionNumber;
        friendBook = [[TKAddressBook alloc] init];
        friendBook.recordID = book.recordID;
        friendBook.rowSelected = book.rowSelected;
        friendBook.email = book.email;
        friendBook.name = book.name;
        friendBook.tel = book.tel;
        friendBook.thumbnail = book.thumbnail;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
    [self initView];
    if (friendBook == nil) {
        [self getFriendInfo];
    }
    else{
        [self initFriend];
    }
}

-(void)initFriend
{
    userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
    userImage.layer.cornerRadius = 5.0f;
    userImage.layer.masksToBounds = YES;
    Dao *shareDao = [Dao sharedDao];
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,friendBook.fuuid];
    [userImage setImageURL:imageUrl];
    if (friendBook.sex == 1) {
        sexImage.image = [UIImage imageNamed:@"男.png"];
    }
    else{
        sexImage.image = [UIImage imageNamed:@"女.png"];
    }
    [sendButton successStyle];
    [giveButton infoStyle];
    nameLabel.text = friendBook.name;
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
    
    
    
}

-(void)initView
{
    
}

-(IBAction)sendMessage:(id)sender
{

}

-(void)getFriendInfo
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
    self.userDic = [dict objectForKey:@"userinfo"];
    
    NSString *sexStr = [userDic objectForKey:@"sex"];
    if (sexStr == nil || [sexStr isMemberOfClass:[NSNull class]]) {
        sexStr = @"";
    }
    int sex = [sexStr intValue];
    if (sex != 1) {
        sex = 2;
    }

    
    NSString *nichen = [userDic objectForKey:@"nickname"];
    if (nichen == nil || [nichen isMemberOfClass:[NSNull class]]) {
        nichen = @"匿名";
    }
  
    
    NSString *sign = [userDic objectForKey:@"signature"];
    if (sign == nil || [sign isMemberOfClass:[NSNull class]]) {
        sign = @"暂无签名";
    }
    
    
    friendBook = [[TKAddressBook alloc] init];
    friendBook.fusername = nichen;
    friendBook.name = nichen;
    friendBook.sign = sign;
    friendBook.sex = sex;
    friendBook.fuuid = uuid;
    [self initFriend];
    
    
}

-(IBAction)giveTicket:(id)sender
{
    NSArray *array = [[NSArray alloc] initWithObjects:friendBook, nil];
    HeGiveTicketV *giveTicket = [[HeGiveTicketV alloc] initWithArray:array];
    giveTicket.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giveTicket animated:YES];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
