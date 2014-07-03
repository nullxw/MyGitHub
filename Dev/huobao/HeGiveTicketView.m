//
//  HeGiveTicketView.m
//  huobao
//
//  Created by Tony He on 14-5-16.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeGiveTicketView.h"
#import "AsynImageView.h"

@interface HeGiveTicketView ()
@property(strong,nonatomic)IBOutlet UITableView *giveTicketTable;
@property(strong,nonatomic)NSArray *giveTicketListArray;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;

@end

@implementation HeGiveTicketView
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
    self.giveTicketTable.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
}

-(void)commitAction:(id)sender
{

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
	UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	
    NSInteger row = indexPath.row;
    CGFloat imageW = 50.0;
    CGFloat imageY = 5.0f;
    CGFloat imageX = 10.0f;
	TKAddressBook *addressBook = [giveTicketListArray objectAtIndex:row];
	
	NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)row],@"PicSRC", nil];
    NSString *apiUrl = @"www.baidu.com";
    if ([tempDic objectForKey:@"PicSRC"] != [NSNull null])
    {
        NSString *picSRC = [tempDic objectForKey:@"PicSRC"];
        
        if ([self picLoaded:picSRC]) {
            int index = [self findAsyImage:picSRC];
            if(index >= 0){
                AsynImageView *asyncImage = [_pictureArray objectAtIndex:index];
                [cell.contentView addSubview:asyncImage];
            }
        }
        else{
            AsynImageView *asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
            asyncImage.tag = 1;
            //图片还没记载完成的时候默认的加载图片
            asyncImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
            [_downloadedArray addObject:picSRC];
            NSString *picURL = [NSString stringWithFormat:@"%@/%@",apiUrl,picSRC];
            
            asyncImage.imageURL = picURL;
            /****设置图片的边角为圆角****/
            asyncImage.layer.cornerRadius = 3.0;
            asyncImage.layer.borderWidth = 1.0f;
            asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
            asyncImage.layer.masksToBounds = YES;
            [_pictureArray addObject:asyncImage];
            [cell.contentView addSubview:asyncImage];
            
        }
    }
    else
    {
        AsynImageView *asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        asyncImage.imageURL = nil;
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"事例图片.png"];
        NSString *picURL = @"null";
        [_downloadedArray addObject:picURL];
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 3.0;
        asyncImage.layer.borderWidth = 1.0f;
        asyncImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [_pictureArray addObject:asyncImage];
        [cell.contentView addSubview:asyncImage];
        
        
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
	nameLabel.frame = CGRectMake(imageX + imageW + 10, 25.0, 200, 20.0);
    nameLabel.text = @"小伙伴23号";
    [cell.contentView addSubview:nameLabel];
    
    UIImageView *releaseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"releaseEnable.png"]];
    releaseIcon.frame = CGRectMake(self.view.bounds.size.width - 120.0, 20.0, 30, 30);
    [cell.contentView addSubview:releaseIcon];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.textColor = [UIColor redColor];
    numberLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    numberLabel.text = @"X 1";
    numberLabel.frame = CGRectMake(self.view.bounds.size.width - 80.0, 20.0, 30, 30);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addEnable.png"]];
    addIcon.frame = CGRectMake(self.view.bounds.size.width - 40.0, 20.0, 30, 30);
    [cell.contentView addSubview:addIcon];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
