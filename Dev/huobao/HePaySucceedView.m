//
//  HePaySucceedView.m
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HePaySucceedView.h"
#import "CPTextViewPlaceholder.h"
#import "UIButton+Bootstrap.h"

@interface HePaySucceedView ()
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UIButton *checkBaoBoxButton;
@property(strong,nonatomic)IBOutlet UIButton *shareButton;
@property(strong,nonatomic)IBOutlet CPTextViewPlaceholder *shareTF;

@end

@implementation HePaySucceedView
@synthesize titleLabel;
@synthesize checkBaoBoxButton;
@synthesize shareButton;
@synthesize shareTF;
@synthesize type;
@synthesize mydic;

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
        label.text = @"参加成功";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        mydic = [[NSDictionary alloc] initWithDictionary:dic];
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
    NSString *name = [mydic objectForKey:@"name"];
    if (name == nil || [name isMemberOfClass:[NSNull class]]) {
        name = @"匿名";
    }
    titleLabel.text = name;
    
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
    
    if (type == 1) {
        [checkBaoBoxButton setTitle:@"查看活箱" forState:UIControlStateNormal];
    }
    else{
        [checkBaoBoxButton setTitle:@"查看宝箱" forState:UIControlStateNormal];
    }
    titleLabel.textColor = [UIColor blueColor];
    [checkBaoBoxButton successStyle];
    [shareButton infoStyle];
    
    shareTF.hidden = YES;
    CGRect frame = shareTF.frame;
    shareTF = [[CPTextViewPlaceholder alloc] init];
    shareTF.frame = frame;
    shareTF.placeholder = @"分享你的心得";
    shareTF.layer.cornerRadius = 5.0f;
    shareTF.layer.borderWidth = 1.0f;
    shareTF.layer.borderColor = [[UIColor grayColor] CGColor];
    shareTF.layer.masksToBounds = YES;
    shareTF.delegate = self;
    shareTF.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [self.view addSubview:shareTF];
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    finishButton.title = @"完成";
    NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    tb.items = bArray;
    shareTF.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    
    shareTF.returnKeyType = UIReturnKeyDefault;
    shareTF.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

-(void)finish:(id)sender
{
    if ([shareTF isFirstResponder]) {
        [shareTF resignFirstResponder];
    }
}

-(void)initView
{
    
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)shareWithMyfriend:(id)sender
{
//    [self showTipLabelWith:@"分享成功"];
    
    
    NSString *imageUrl = @"http://115.28.18.130/huobao_us//data/event/original/8b69d6b8-aaa2-3cba-b2f3-a773a2a0eabb.jpg";
    
    NSString *comName = @"活宝的分享";
    NSString *DName = @"活宝的分享";
    
   
    NSString *activityUrl = @"http://115.28.18.130/";
    NSString *wxtitle = [ShareSDK getClientNameWithType:ShareTypeWeixiTimeline];
    UIImage *wxImage = [ShareSDK getClientIconWithType:ShareTypeWeixiTimeline];
    id<ISSShareActionSheetItem> wxItem =
    [ShareSDK shareActionSheetItemWithTitle:wxtitle icon:wxImage clickHandler:^{
        // 请⾃自⾏行添加点击该分享菜单项时的⾏行为代码
        NSString *wxcontentString = [NSString stringWithFormat:@"我刚通过活宝看到【%@】优惠活动:%@，你也来试试!!!",comName,DName];
        id<ISSContent> wxpublishContent = [ShareSDK content:wxcontentString
                                             defaultContent:nil
                                                      image:[ShareSDK imageWithUrl:imageUrl]
                                                      title:wxcontentString
                                                        url:activityUrl
                                                description:@"活宝App"
                                                  mediaType:SSPublishContentMediaTypeNews];
        [ShareSDK shareContent:wxpublishContent type:ShareTypeWeixiTimeline authOptions:nil statusBarTips:YES result:nil];
    }];
    
    NSString *wxFtitle = [ShareSDK getClientNameWithType:ShareTypeWeixiSession];
    UIImage *wxFImage = [ShareSDK getClientIconWithType:ShareTypeWeixiSession];
    id<ISSShareActionSheetItem> wxFItem =
    [ShareSDK shareActionSheetItemWithTitle:wxFtitle icon:wxFImage clickHandler:^{
        // 请⾃自⾏行添加点击该分享菜单项时的⾏行为代码
        NSString *wxcontentString = [NSString stringWithFormat:@"我刚通过天天惠生活看到【%@】优惠活动:%@，你也来试试!!!",comName,DName];
        id<ISSContent> wxpublishContent = [ShareSDK content:wxcontentString
                                             defaultContent:nil
                                                      image:[ShareSDK imageWithUrl:imageUrl]
                                                      title:@"活宝"
                                                        url:activityUrl
                                                description:@"活宝App"
                                                  mediaType:SSPublishContentMediaTypeNews];
        [ShareSDK shareContent:wxpublishContent type:ShareTypeWeixiSession authOptions:nil statusBarTips:YES result:nil];
    }];
    
    NSString *contentString = [NSString stringWithFormat:@"我刚通过天天惠生活看到【%@】优惠活动:%@，你也来试试!!!",comName,DName];
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:@"活宝"
                                                  url:activityUrl
                                          description:@"活宝App"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          wxFItem,
                          wxItem,
                          
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          nil];
    
    [ShareSDK showShareActionSheet:nil shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(IBAction)checkMyBox:(id)sender
{
    NSArray *array = self.navigationController.childViewControllers;
    for (UIViewController *controller in array) {
        if ([controller isMemberOfClass:[HeMyBaoBoxView class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    if (type == 1) {
        HeMyHuoBoxView *huoBoxView = [[HeMyHuoBoxView alloc] init];
        huoBoxView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:huoBoxView animated:YES];
    }
    else{
        HeMyBaoBoxView *baoBoxView = [[HeMyBaoBoxView alloc] init];
        baoBoxView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baoBoxView animated:YES];
    }
    
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
