//
//  HePassportViewController.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HePassportViewController.h"
#import "AsynImageView.h"

@interface HePassportViewController ()
@property(strong,nonatomic)IBOutlet AsynImageView *qrCodeImage;
@property(strong,nonatomic)IBOutlet UIImageView *bgImage;
@property(strong,nonatomic)IBOutlet UIImageView *frameImage;
@property(strong,nonatomic)IBOutlet UIImageView *statueIcon;
@property(strong,nonatomic)IBOutlet UIImageView *lineImage;
@property(strong,nonatomic)IBOutlet AsynImageView *userImage;
@property(strong,nonatomic)IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UILabel *signLabel;

@property(strong,nonatomic)IBOutlet UIView *bgView;
@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UIImageView *logoImage;
@property(strong,nonatomic)IBOutlet UIImageView *me_bg_Image;
@property(strong,nonatomic)IBOutlet UILabel *tipLabel;

@end

@implementation HePassportViewController
@synthesize qrCodeImage;
@synthesize bgImage;
@synthesize statueIcon;
@synthesize userImage;
@synthesize nameLabel;
@synthesize signLabel;
@synthesize lineImage;
@synthesize frameImage;

@synthesize bgView;
@synthesize loginButton;
@synthesize logoImage;
@synthesize me_bg_Image;
@synthesize tipLabel;

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
        label.text = @"通行证";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUser];
    [self initControl];
    [self initView];
    
}


-(void)initUser
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updataData) name:@"modifyUser" object:nil];
    [notificationCenter addObserver:self selector:@selector(loginSucceed:) name:@"loginSucceed" object:nil];
    
    
}
-(void)initControl
{
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if (sysModel.user.stateID == 1) {
        qrCodeImage.hidden = NO;
        bgImage.hidden = NO;
        statueIcon.hidden = NO;
        userImage.hidden = NO;
        nameLabel.hidden = NO;
        signLabel.hidden = NO;
        lineImage.hidden = NO;
        frameImage.hidden = NO;
        bgView.hidden = YES;
    }
    else{
        qrCodeImage.hidden = YES;
        bgImage.hidden = YES;
        statueIcon.hidden = YES;
        userImage.hidden = YES;
        nameLabel.hidden = YES;
        signLabel.hidden = YES;
        lineImage.hidden = YES;
        frameImage.hidden = YES;
        
        [self.view addSubview:bgView];
        bgView.hidden = NO;
    }
    
    [loginButton infoStyle];
    
    userImage.placeholderImage = sysModel.user.userImage.placeholderImage;
    self.userImage.imageURL = sysModel.user.userImage.imageURL;
    
    self.userImage.layer.cornerRadius = 5;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0.0f;
    self.userImage.layer.borderColor = [[UIColor clearColor] CGColor];
   
    
//    self.userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
    self.qrCodeImage.placeholderImage = [UIImage imageNamed:@"二维码"];
//    self.qrCodeImage.tag = 100;
    Dao *shareDao = [Dao sharedDao];
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,sysModel.user.uuid];
    [userImage setImageURL:imageUrl];
    
    NSString *qrCodeImageUrl = [NSString stringWithFormat:@"%@/%@",shareDao.imageBaseUrl,sysModel.user.passport];
    self.qrCodeImage.tag = 100;
//    self.qrCodeImage.imageURL = qrCodeImageUrl;
    [self.qrCodeImage setImageURL:qrCodeImageUrl];
    
    self.nameLabel.text = sysModel.user.nichen;
    if (nameLabel.text == nil || [nameLabel.text isEqualToString:@""]) {
        nameLabel.text = @"匿名";
    }
    self.signLabel.text = sysModel.user.sign;
    if (signLabel.text == nil || [signLabel.text isEqualToString:@""]) {
        signLabel.text = @"暂无签名";
    }
    if (sysModel.user.statue == 1) {
        statueIcon.hidden = NO;
    }
    else{
        statueIcon.hidden = YES;
//        bgImage.image = [UIImage imageNamed:@"silver_bg.png"];
    }
}

-(void)updataData
{
    [self initControl];
}

-(void)loginSucceed:(id)sender
{
    [self initControl];
}

-(void)initView
{
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        CGRect frame = self.lineImage.frame;
        frame.origin.y = frame.origin.y - 20.0;
        lineImage.frame = frame;
        
        frame = self.userImage.frame;
        frame.origin.y = frame.origin.y - 30.0;
        userImage.frame = frame;
        
        frame = self.nameLabel.frame;
        frame.origin.y = frame.origin.y - 30.0;
        nameLabel.frame = frame;
        
        frame = self.signLabel.frame;
        frame.origin.y = frame.origin.y - 30.0;
        signLabel.frame = frame;
        
        frame = self.statueIcon.frame;
        frame.origin.y = frame.origin.y - 30.0;
        statueIcon.frame = frame;
        
        frame = frameImage.frame;
        frame.size.height = frame.size.height - 100.0f;
        frameImage.frame = frame;
    }
    
}

-(IBAction)loginAction:(id)sender
{
    HeLoginView *loginView = [[HeLoginView alloc] initWithNibName:nil bundle:nil];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyUser" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSucceed" object:nil];
}

@end
