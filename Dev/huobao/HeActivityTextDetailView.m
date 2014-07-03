//
//  HeActivityTextDetailView.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeActivityTextDetailView.h"

@interface HeActivityTextDetailView ()
@property(strong,nonatomic)IBOutlet UITableView *infoTable;
@property(strong,nonatomic)NSMutableDictionary *activityDic;

@end

@implementation HeActivityTextDetailView
@synthesize infoTable;
@synthesize activityDic;

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

-(id)initWithActivityDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
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

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)initView
{
    infoTable.backgroundView = nil;
    [self setExtraCellLineHidden:infoTable];
    infoTable.backgroundColor = [UIColor whiteColor];
    infoTable.separatorColor = [UIColor colorWithRed:74.0f/255.0f green:172.0f/255.0f blue:243.0f/255.0f alpha:1.0];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.infoTable.tableFooterView = footerView;
    
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
   
    NSInteger section = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (section) {
        case 0:
        {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor colorWithRed:65.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
            titleLabel.numberOfLines = 2;
            titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.5];
            
            NSString *titleString = [activityDic objectForKey:@"name"];
            if (titleString == nil || [titleString isMemberOfClass:[NSNull class]]) {
                titleString = @"暂无活动名";
            }
            titleLabel.text = titleString;
            titleLabel.frame = CGRectMake(20, 10, 280, 40);
            [cell.contentView addSubview:titleLabel];
            
            UILabel *timeAddressLabel = [[UILabel alloc] init];
            timeAddressLabel.backgroundColor = [UIColor clearColor];
            timeAddressLabel.textColor = [UIColor blackColor];
            timeAddressLabel.numberOfLines = 1;
            timeAddressLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            
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
            NSString *timeString = [NSString stringWithFormat:@"%@/%@",starttime,endtime];
            
            NSString *addressString = [activityDic objectForKey:@"address"];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[addressString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            NSString *content = attributedString.string;
            
            if (content == nil || [content isMemberOfClass:[NSNull class]]) {
                content = @"地址不详";
            }
            
            timeAddressLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
            NSString *timeAddress = @"演出时间:";
            timeAddressLabel.text = timeAddress;
            timeAddressLabel.textAlignment = NSTextAlignmentLeft;
            timeAddressLabel.frame = CGRectMake(20, 55, 280, 20);
            [cell.contentView addSubview:timeAddressLabel];
            
            UILabel *timeAddressLabel1 = [[UILabel alloc] init];
            timeAddressLabel1.backgroundColor = [UIColor clearColor];
            timeAddressLabel1.textColor = [UIColor blackColor];
            timeAddressLabel1.numberOfLines = 1;
            timeAddressLabel1.font = [UIFont fontWithName:@"Helvetica" size:15];
            timeAddressLabel1.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
            NSString *time1 = [[NSString alloc] initWithFormat:@"%@",timeString];
            timeAddressLabel1.text = time1;
            timeAddressLabel1.textAlignment = NSTextAlignmentLeft;
            timeAddressLabel1.frame = CGRectMake(20, 80, 280, 20);
            [cell.contentView addSubview:timeAddressLabel1];
            
            UILabel *addressLabel = [[UILabel alloc] init];
            addressLabel.backgroundColor = [UIColor clearColor];
            addressLabel.textColor = [UIColor blackColor];
            addressLabel.numberOfLines = 1;
            addressLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            addressLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
            NSString *address = @"演出地点:";
            addressLabel.text = address;
            addressLabel.textAlignment = NSTextAlignmentLeft;
            addressLabel.frame = CGRectMake(20, 105, 280, 20);
            [cell.contentView addSubview:addressLabel];
            
            UILabel *addressLabel1 = [[UILabel alloc] init];
            addressLabel1.backgroundColor = [UIColor clearColor];
            addressLabel1.textColor = [UIColor blackColor];
            addressLabel1.numberOfLines = 1;
            addressLabel1.font = [UIFont fontWithName:@"Helvetica" size:15];
            addressLabel1.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
            NSString *address1 = [[NSString alloc] initWithFormat:@"%@",content];
            addressLabel1.text = address1;
            addressLabel1.textAlignment = NSTextAlignmentLeft;
            addressLabel1.frame = CGRectMake(20, 130, 280, 20);
            [cell.contentView addSubview:addressLabel1];
            
            break;
        }
        case 1:
        {
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
                textView.frame = CGRectMake(20, 10, 280, 30);
            }
            else{
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
                CGSize constraint = CGSizeMake(260,2000);
                CGSize size = [attributedString.string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
                textView.frame = CGRectMake(20, 10, 280, size.height);
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
    
    switch (section) {
        case 0:
        {
            return 160.0f;
            break;
        }
        case 1:
        {
            NSString *contentStirng = [activityDic objectForKey:@"introduction"];
            if (contentStirng == nil || [contentStirng isMemberOfClass:[NSNull class]] || [contentStirng isEqualToString:@""]) {
                contentStirng = @"暂无简介";
                return 50.0f;
            }
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[contentStirng dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
            CGSize constraint = CGSizeMake(280,2000);
            CGSize size = [attributedString.string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
            //因为上下个空出五个点出来
            return size.height + 15;
            break;
        }
        default:
            break;
    }
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
