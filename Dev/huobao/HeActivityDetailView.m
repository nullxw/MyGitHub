//
//  HeActivityDetailView.m
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeActivityDetailView.h"
#import "UIButton+Bootstrap.h"
#import "AMBlurView.h"
#import "UIImageView+LBBlurredImage.h"
#import "HeTicketButton.h"
#import "HeAccountCenterView.h"
#import "HeActivityTextDetailView.h"
#import "HeGuestView.h"
#import "HeContactUsView.h"
#import "HeJoinView.h"
#import "HePictureBrowser.h"
#import "HeAddressView.h"

@interface HeActivityDetailView ()

@property(strong,nonatomic)IBOutlet UITableView *activityTable;
@property(strong,nonatomic)NSArray *myDataSource;
@property(strong,nonatomic)IBOutlet AsynImageView *headerBgView;//顶部背景图
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UILabel *timeLabel;
@property(strong,nonatomic)IBOutlet UILabel *addressLabel;
@property(strong,nonatomic)IBOutlet UIImageView *timeIcon;
@property(strong,nonatomic)IBOutlet UIImageView *addressIcon;
@property(strong,nonatomic)IBOutlet UIButton *commitButton;
@property(strong,nonatomic)UIButton *popViewButton;
@property(strong,nonatomic)IBOutlet UIImageView *arrowIcon;
@property(strong,nonatomic)UIView *selectBgImage;
@property(strong,nonatomic)HeTicketButton *studentTicketButton;
@property(strong,nonatomic)HeTicketButton *parentTicketButton;
@property(strong,nonatomic)HeTicketButton *freeTicketButton;
@property(strong,nonatomic)NSMutableDictionary *activityDic;

@end

@implementation HeActivityDetailView
@synthesize activityTable;
@synthesize myDataSource;
@synthesize headerBgView;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize addressLabel;
@synthesize timeIcon;
@synthesize addressIcon;
@synthesize commitButton;
@synthesize popViewButton;
@synthesize arrowIcon;
@synthesize selectBgImage;
@synthesize studentTicketButton;
@synthesize parentTicketButton;
@synthesize freeTicketButton;
@synthesize activityDic;
@synthesize type;

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
        label.text = @"活动详情";
        [label sizeToFit];
    }
    return self;
}

-(id)initWithActivityDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.activityDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
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
    headerBgView.placeholderImage = [UIImage imageNamed:@"huobaolist_bg.png"];
    NSString *original = [activityDic objectForKey:@"cover"];
    if (original == nil || [original isMemberOfClass:[NSNull class]]) {
        original = @"";
    }
   
    NSString *app = [original stringByReplacingOccurrencesOfString:@"original" withString:@"app"];
    
    Dao *shareDao = [Dao sharedDao];
    headerBgView.imageURL = [NSString stringWithFormat:@"%@/%@",shareDao.imageBaseUrl,app];
    
    headerBgView.userInteractionEnabled = YES;
    [headerBgView addSubview:titleLabel];
    [headerBgView addSubview:timeLabel];
    [headerBgView addSubview:addressLabel];
    [headerBgView addSubview:timeIcon];
    [headerBgView addSubview:addressIcon];
    [headerBgView addSubview:commitButton];
    [headerBgView addSubview:arrowIcon];
    
    NSString *titleString = [activityDic objectForKey:@"name"];
    if (titleString == nil || [titleString isMemberOfClass:[NSNull class]]) {
        titleString = @"2014秦皇岛海阳演唱会";
    }
    titleLabel.text = titleString;
    
    NSString *endtime = [activityDic objectForKey:@"endtime"];
    if (endtime == nil || [endtime isMemberOfClass:[NSNull class]]) {
        endtime = @"2014.08.09";
    }
    NSString *starttime = [activityDic objectForKey:@"starttime"];
    if (starttime == nil || [starttime isMemberOfClass:[NSNull class]]) {
        starttime = @"2014.08.05";
    }
    if ([starttime length] >= 10) {
        starttime = [starttime substringToIndex:10];
    }
    if ([endtime length] >= 10) {
        endtime = [endtime substringToIndex:10];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@/%@",starttime,endtime];
    timeLabel.text = timeStr;
    
    NSString *addressString = [activityDic objectForKey:@"address"];
    if (addressString == nil || [addressString isMemberOfClass:[NSNull class]]) {
        addressString = @"广东广州体育东";
    }
    addressLabel.text = addressString;
    
    
    activityTable.tableHeaderView = headerBgView;
    original_tableframe = activityTable.frame;
    CGRect tableframe = activityTable.frame;
    tableframe.origin.y = 0;
    activityTable.frame = tableframe;
    
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
    myDataSource = [[NSArray alloc] initWithObjects:@"主办单位",@"活动详情",@"参加的人",@"照片墙",@"标签", nil];
    
    popViewButton = [[UIButton alloc] init];
    popViewButton.alpha = 0.8;
    popViewButton.layer.cornerRadius = 2.0;
    popViewButton.layer.masksToBounds = YES;
    [popViewButton setBackgroundImage:[UIImage imageNamed:@"popViewBg.png"] forState:UIControlStateNormal];
    
    CGFloat buttonX = (self.view.bounds.size.width - 80)/2;
    CGFloat buttonH = 20.0f;
    CGFloat buttonY = [[UIScreen mainScreen] bounds].size.height - 20.0 - 44.0f - buttonH ;
    CGFloat buttonW = 80.0f;
    [popViewButton addTarget:self action:@selector(popViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [popViewButton addTarget:self action:@selector(popViewButtonClick:) forControlEvents:UIControlEventTouchDragOutside];
    popViewButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [self.view addSubview:popViewButton];
    
    arrowIcon.hidden = YES;
    
    selectBgImage = [[UIView alloc] initWithFrame:CGRectMake(0, headerBgView.frame.size.height, self.view.bounds.size.width, 175.0f)];
    selectBgImage.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    studentTicketButton = [[HeTicketButton alloc] initWithFrame:CGRectMake(20, 10, 280.0f, 45.0f) Type:0 count:27];
    studentTicketButton.tag = 0;
    [studentTicketButton addTarget:self action:@selector(ticketButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    parentTicketButton = [[HeTicketButton alloc] initWithFrame:CGRectMake(20, 65, 280.0f, 45.0f) Type:1 count:2];
    parentTicketButton.tag = 1;
    [parentTicketButton addTarget:self action:@selector(ticketButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    freeTicketButton = [[HeTicketButton alloc] initWithFrame:CGRectMake(20, 120, 280.0f, 45.0f) Type:2 count:7];
    freeTicketButton.tag = 2;
    [freeTicketButton addTarget:self action:@selector(ticketButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectBgImage addSubview:studentTicketButton];
    [selectBgImage addSubview:parentTicketButton];
    [selectBgImage addSubview:freeTicketButton];
    selectBgImage.hidden = YES;
    commitButton.tag = 1;
    [self.view insertSubview:selectBgImage belowSubview:activityTable];
    
    UIView *lucencyView = [[UIView alloc] init];
   
    lucencyView.layer.borderWidth = 0.0f;
    lucencyView.layer.borderColor = [[UIColor clearColor] CGColor];
    lucencyView.layer.masksToBounds = YES;
    lucencyView.frame = CGRectMake(0, 0, headerBgView.bounds.size.width, headerBgView.bounds.size.height);
    lucencyView.backgroundColor = [UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:0.5];
    [headerBgView insertSubview:lucencyView atIndex:0];
    
}

-(void)initView
{
    [commitButton successStyle];
    [self setExtraCellLineHidden:activityTable];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.activityTable.tableFooterView = footerView;

}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ticketButtonClick:(HeTicketButton *)button
{
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 0:
        {
            studentTicketButton.selected = YES;
            parentTicketButton.selected = NO;
            freeTicketButton.selected = NO;
            break;
        }
        case 1:
        {
            parentTicketButton.selected = YES;
            studentTicketButton.selected = NO;
            freeTicketButton.selected = NO;
            break;
        }
        case 2:
        {
            freeTicketButton.selected = YES;
            studentTicketButton.selected = NO;
            parentTicketButton.selected = NO;
            break;
        }
        default:
            break;
    }
    HeJoinsheetView *joinsheet = [[HeJoinsheetView alloc] initWithActivityDic:self.activityDic];
    joinsheet.type = type;
    joinsheet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:joinsheet animated:YES];
}

-(void)popViewButtonClick:(id)sender
{
    
    NSArray *buttonTitleArray = [[NSArray alloc] init];
    buttonTitleArray = @[@"详情",@"嘉宾",@"联系",@"参加的人",@"照片墙",@"地点"];
    NSArray *buttonIconArray = [[NSArray alloc] init];
    buttonIconArray = @[@"活动详情图标.png",@"活动嘉宾图标.png",@"活动联系图标.png",@"活动参加的人图标.png",@"活动照片墙图标.png",@"活动地点图标.png"];
    
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:buttonTitleArray withShareButtonImagesName:buttonIconArray];
    [lxActivity showInView:self.view];
}

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    switch ((int)imageIndex) {
        case 0:
        {
            HeActivityTextDetailView *infoDetailView = [[HeActivityTextDetailView alloc] initWithActivityDic:activityDic];
            infoDetailView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoDetailView animated:YES];
            break;
        }
        case 1:
        {
            HeGuestView *guestView = [[HeGuestView alloc] init];
            guestView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:guestView animated:YES];
            break;
        }
        case 2:
        {
            HeContactUsView *contactUs = [[HeContactUsView alloc] init];
            contactUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contactUs animated:YES];
            break;
        }
        case 3:
        {
            HeJoinView *joinView = [[HeJoinView alloc] init];
            joinView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:joinView animated:YES];
            break;
        }
        case 4:
        {
            HePictureBrowser *picBrowser = [[HePictureBrowser alloc] init];
            picBrowser.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:picBrowser animated:YES];
            break;
        }
        case 5:
        {
            HeAddressView *addressView = [[HeAddressView alloc] initAddressViewWithDic:activityDic];
            addressView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressView animated:YES];
            break;
        }
        
        default:
            break;
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(IBAction)commitButtonClick:(id)sender
{
    HeJoinsheetView *joinsheet = [[HeJoinsheetView alloc] initWithActivityDic:self.activityDic];
    joinsheet.type = type;
    joinsheet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:joinsheet animated:YES];
    
    return;
    
    CGRect iconframe = arrowIcon.frame;
    iconframe.origin.y = headerBgView.frame.size.height - iconframe.size.height;
    arrowIcon.frame = iconframe;
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"动画开始");
    CGRect frame = self.activityTable.frame;
    
    if (button.tag == 1) {
        activityTable.tableHeaderView = nil;
        [self.view addSubview:headerBgView];
        activityTable.frame = original_tableframe;
        
        CGRect tempframe = original_tableframe;
        
        frame.origin.y = tempframe.origin.y + 175.0;
        button.tag = 2;
        [commitButton setTitle:@"取消参加" forState:UIControlStateNormal];
        selectBgImage.hidden = NO;
        arrowIcon.hidden = NO;
        studentTicketButton.selected = NO;
        parentTicketButton.selected = NO;
        freeTicketButton.selected = NO;
    }
    else{
//        [self.view addSubview:headerBgView];
        
    
        [commitButton setTitle:@"我要参加" forState:UIControlStateNormal];
        frame.origin.y = frame.origin.y - 175.0;
        button.tag = 1;
        
        
    }
    

    [UIView animateWithDuration:.5 animations:^{
        self.activityTable.frame = frame;
        
    } completion:^(BOOL finished) {
        NSLog(@"finish");
        //NSLog(@"tapsetenable");
        if (button.tag == 1) {
            selectBgImage.hidden = YES;
            arrowIcon.hidden = selectBgImage.hidden;
            CGRect tempframe = original_tableframe;
            tempframe.origin.y = 0;
            activityTable.frame = tempframe;
            activityTable.tableHeaderView = headerBgView;
        }
        else{
            
        }
        
    }];
    
    [UIView setAnimationsEnabled:YES];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myDataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
	UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;


    CGFloat iconX = 10.0f;
    CGFloat iconY = 10.0f;
    CGFloat iconW = 30.0f;
    CGFloat iconH = 30.0f;
    
    CGFloat labelX = 45.0f;
    CGFloat labelW = 260.0f;
    switch (row) {
        case 0:
        {
            UILabel *subtitleLabel = [[UILabel alloc] init];
            subtitleLabel.backgroundColor = [UIColor clearColor];
            subtitleLabel.textColor = [UIColor blackColor];
            subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            subtitleLabel.frame = CGRectMake(10, 10, 300, 20);
            [cell.contentView addSubview:subtitleLabel];
            NSString *titleString = [activityDic objectForKey:@"name"];
            if (titleString == nil || [titleString isMemberOfClass:[NSNull class]]) {
                titleString = @"2014秦皇岛海阳演唱会";
            }
            subtitleLabel.text = titleString;
            
           
            
            UIImageView *subtimeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_timeIcon.png"]];
            subtimeIcon.frame = CGRectMake(iconX, subtitleLabel.frame.origin.y + subtitleLabel.frame.size.height + 5, iconW, iconH);
            [cell.contentView addSubview:subtimeIcon];
            
            UILabel *subtimeLabel = [[UILabel alloc] init];
            subtimeLabel.backgroundColor = [UIColor clearColor];
            subtimeLabel.textColor = [UIColor grayColor];
            subtimeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            subtimeLabel.frame = CGRectMake(labelX, subtimeIcon.frame.origin.y, labelW, iconH);
            [cell.contentView addSubview:subtimeLabel];
            
            NSString *endtime = [activityDic objectForKey:@"endtime"];
            if (endtime == nil || [endtime isMemberOfClass:[NSNull class]]) {
                endtime = @"2014.08.09";
            }
            NSString *starttime = [activityDic objectForKey:@"starttime"];
            if (starttime == nil || [starttime isMemberOfClass:[NSNull class]]) {
                starttime = @"2014.08.05";
            }
            if ([starttime length] >= 10) {
                starttime = [starttime substringToIndex:10];
            }
            if ([endtime length] >= 10) {
                endtime = [endtime substringToIndex:10];
            }
            NSString *timeStr = [NSString stringWithFormat:@"%@/%@",starttime,endtime];
            subtimeLabel.text = timeStr;
            
            
            
            break;
        }
        case 1:
        {
            UIImageView *subaddressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_addressIcon.png"]];
            subaddressIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [cell.contentView addSubview:subaddressIcon];
            
            UILabel *subaddressLabel = [[UILabel alloc] init];
            subaddressLabel.backgroundColor = [UIColor clearColor];
            subaddressLabel.textColor = [UIColor grayColor];
            subaddressLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            subaddressLabel.frame = CGRectMake(labelX, iconY, labelW, iconH);
            [cell.contentView addSubview:subaddressLabel];
            
            
            NSString *addressString = [activityDic objectForKey:@"address"];
            
            if (addressString == nil || [addressString isMemberOfClass:[NSNull class]]) {
                addressString = @"广东广州体育东";
            }
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[addressString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSString *content = attributedString.string;
            
            
            subaddressLabel.text = content;
            break;
        }
        case 2:
        {
            UIImageView *subtimeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_jifenIcon.png"]];
            subtimeIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [cell.contentView addSubview:subtimeIcon];
            
            UILabel *subtimeLabel = [[UILabel alloc] init];
            subtimeLabel.backgroundColor = [UIColor clearColor];
            subtimeLabel.textColor = [UIColor grayColor];
            subtimeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            subtimeLabel.frame = CGRectMake(labelX, iconY, labelW, iconH);
            [cell.contentView addSubview:subtimeLabel];
            
            NSString *jifenString = [activityDic objectForKey:@"creditrequirements"];
            if (jifenString == nil || [jifenString isMemberOfClass:[NSNull class]]) {
                jifenString = @"1";
            }
            subtimeLabel.text = [NSString stringWithFormat:@"消耗 %@ 积分",jifenString];
            break;
        }
        case 3:
        {
            UIImageView *subtimeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_joinIcon.png"]];
            subtimeIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [cell.contentView addSubview:subtimeIcon];
            
            UILabel *subtimeLabel = [[UILabel alloc] init];
            subtimeLabel.backgroundColor = [UIColor clearColor];
            subtimeLabel.textColor = [UIColor grayColor];
            subtimeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            subtimeLabel.frame = CGRectMake(labelX, iconY, labelW, iconH);
            [cell.contentView addSubview:subtimeLabel];
            
            NSString *joinNumberString = [activityDic objectForKey:@"quantity"];
            if (joinNumberString == nil || [joinNumberString isMemberOfClass:[NSNull class]]) {
                joinNumberString = @"0";
            }
            subtimeLabel.text = [NSString stringWithFormat:@"%@ 人已参与",joinNumberString];
            
            break;
        }
        case 4:
        {
            UIImageView *subtimeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_infoIcon.png"]];
            subtimeIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [cell.contentView addSubview:subtimeIcon];
            
            
            
            UITextView *textView = [[UITextView alloc] init];
            textView.editable = NO;
            
            textView.backgroundColor = [UIColor clearColor];
            
            NSString *htmlString = [activityDic objectForKey:@"introduction"];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            textView.attributedText = attributedString;
            textView.showsHorizontalScrollIndicator = NO;
            textView.showsVerticalScrollIndicator = NO;
            
            UILabel *subtimeLabel = [[UILabel alloc] init];
            subtimeLabel.backgroundColor = [UIColor clearColor];
            subtimeLabel.textColor = [UIColor grayColor];
            subtimeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            
        
            NSString *content = attributedString.string;
            
            if (attributedString.string == nil || [attributedString.string isMemberOfClass:[NSNull class]] || [attributedString.string isEqualToString:@""]) {
                content = @"暂无详细内容";
                textView.textColor = [UIColor grayColor];
                textView.text = content;
                textView.font = [UIFont fontWithName:@"Helvetica" size:15];
                textView.frame = CGRectMake(labelX, iconY, labelW, 30);
            }
            else{
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
                CGSize constraint = CGSizeMake(260,2000);
                CGSize size = [attributedString.string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
                textView.frame = CGRectMake(labelX, iconY, labelW, size.height);
            }
            
            [cell.contentView addSubview:textView];
            
            break;
        }
        default:
            break;
    }
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            return 70.0f;
            break;
        }
        case 1:
        {
            return 50.0f;
            break;
        }
        case 2:
        {
            return 50.0f;
            break;
        }
        case 3:
        {
            return 50.0f;
            break;
        }
        case 4:
        {
            NSString *htmlString = [activityDic objectForKey:@"introduction"];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSString *introduceString = attributedString.string;
            
            if (introduceString == nil || [introduceString isMemberOfClass:[NSNull class]] || [introduceString isEqualToString:@""]) {
                return 50;
            }

            UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
            CGSize constraint = CGSizeMake(260,2000);
            CGSize size = [introduceString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
            //因为上下个空出五个点出来
            return size.height + 15;
            
            break;
        }
        default:
            break;
    }
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
