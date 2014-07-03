//
//  HeAddFriendView.m
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeAddFriendView.h"
#import "TKAddressBook.h"

@interface HeAddFriendView ()
@property(strong,nonatomic)TKAddressBook *friendBook;
@property(strong,nonatomic)IBOutlet AsynImageView *userImage;
@property(strong,nonatomic)IBOutlet UIImageView *sexImage;
@property(strong,nonatomic)IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UILabel *signLabel;
@property(strong,nonatomic)IBOutlet UIButton *addButton;
@property(strong,nonatomic)IBOutlet CPTextViewPlaceholder *textView;
@property(strong,nonatomic)NSString *profile;
@property(strong,nonatomic)NSString *uuid;

@end

@implementation HeAddFriendView
@synthesize friendBook;
@synthesize userImage;
@synthesize sexImage;
@synthesize nameLabel;
@synthesize signLabel;
@synthesize addButton;
@synthesize textView;
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
        label.text = @"添加好友";
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
        NSString *fuid = [userDic objectForKey:@"id"];
        if (fuid == nil || [fuid isMemberOfClass:[NSNull class]]) {
            fuid = @"";
        }
        friendBook = [[TKAddressBook alloc] init];
        friendBook.fuid = fuid;
        
        friendBook.fusername = nichen;
        friendBook.fuuid = fuuid;
        uuid = fuuid;
        friendBook.name = nichen;
        friendBook.sign = sign;
        friendBook.sex = sex;
        
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

-(id)initWithuuid:(NSString *)_uuid
{
    if (self = [super init]) {
        
        friendBook = nil;
        uuid = [[NSString alloc] initWithString:_uuid];
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

-(void)initFriend
{
    userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
    Dao *shareDao = [Dao sharedDao];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,friendBook.fuuid];
    
	[userImage setImageURL:imageUrl];
    
    userImage.layer.cornerRadius = 5.0f;
    userImage.layer.masksToBounds = YES;
    
    [addButton successStyle];
    nameLabel.text = friendBook.fusername;
    if (nameLabel.text == nil) {
        nameLabel.text = @"匿名";
    }
    
    CGRect frame = textView.frame;
    textView = [[CPTextViewPlaceholder alloc] init];
    textView.frame = frame;
    textView.placeholder = @"写下您的留言";
    textView.layer.cornerRadius = 5.0f;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    textView.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [self.view addSubview:textView];
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    finishButton.title = @"完成";
    NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    tb.items = bArray;
    textView.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    
    textView.returnKeyType = UIReturnKeyDefault;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
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

-(void)finish:(id)sender
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    
}
-(IBAction)addFriend:(id)sender
{
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    NSString *uid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:friendBook.fuid,@"uid",uid,@"fuid",nil];
    Dao *shareDao = [Dao sharedDao];
    NSDictionary *dict = [shareDao requestToAddFriend:dic];
    if (dict == nil) {
        [self showTipLabelWith:@"发送请求失败"];
        return;
    }
    int state = [[dict objectForKey:@"state"] intValue];
    if (state != 1) {
        NSString *msg = [dict objectForKey:@"msg"];
        if (msg == nil || [msg isMemberOfClass:[NSNull class]]) {
            msg = @"发送请求失败";
        }
        [self showTipLabelWith:msg];
        return;
    }
    
    [self showTipLabelWith:@"请求成功发送"];
    [self performSelector:@selector(backTolastView:) withObject:nil afterDelay:1.2];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
