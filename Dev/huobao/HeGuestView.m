//
//  HeGuestView.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeGuestView.h"
#import "AsynImageView.h"

@interface HeGuestView ()
@property(strong,nonatomic)IBOutlet UITableView *guestTable;
@property(strong,nonatomic)NSMutableArray *guestData_Source;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;

@end

@implementation HeGuestView
@synthesize guestTable;
@synthesize guestData_Source;
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
        label.text = @"嘉宾";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    update = NO;
    [self initControl];
    [self initView];
    
}

-(void)initControl
{
    guestData_Source = [[NSMutableArray alloc] initWithCapacity:0];
    _pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    _downloadedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    [self setExtraCellLineHidden:guestTable];
    
    
    
}

-(void)arrowButtonClick:(id)sender
{
    update = NO;
    [guestTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:updatePath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    updatePath = nil;
    [guestTable reloadData];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)row],@"PicSRC", nil];
    
    CGFloat imageX = 10.0f;
    CGFloat imageY = 10.0f;
    CGFloat imageW = 60.0f;
    CGFloat imageH = 60.0f;
    
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
            AsynImageView *asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
            asyncImage.tag = 1;
            //图片还没记载完成的时候默认的加载图片
            asyncImage.placeholderImage = [UIImage imageNamed:@"周美慧.png"];
            [_downloadedArray addObject:picSRC];
//            NSString *picURL = [NSString stringWithFormat:@"%@",apiUrl];
            
//            asyncImage.imageURL = picURL;
            /****设置图片的边角为圆角****/
            asyncImage.layer.cornerRadius = 5.0;
            asyncImage.layer.borderWidth = 0.0f;
            asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
            asyncImage.layer.masksToBounds = YES;
            [_pictureArray addObject:asyncImage];
            [cell.contentView addSubview:asyncImage];
            
        }
    }
    else
    {
        AsynImageView *asyncImage = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        asyncImage.imageURL = nil;
        asyncImage.tag = 1;
        //图片还没记载完成的时候默认的加载图片
        asyncImage.placeholderImage = [UIImage imageNamed:@"周美慧.png"];
        NSString *picURL = @"null";
        [_downloadedArray addObject:picURL];
        /****设置图片的边角为圆角****/
        asyncImage.layer.cornerRadius = 5.0;
        asyncImage.layer.borderWidth = 0.0f;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        asyncImage.layer.masksToBounds = YES;
        [_pictureArray addObject:asyncImage];
        
        
        [cell.contentView addSubview:asyncImage];
        
        
    }
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    nameLabel.text = @"周美慧";
    nameLabel.frame = CGRectMake(imageX + imageW + 10, imageY, 200, 20.0f);
    [cell.contentView addSubview:nameLabel];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    infoLabel.text = @"私人剧团活动创始者";
    infoLabel.frame = CGRectMake(imageX + imageW + 10, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 200, 20.0f);
    [cell.contentView addSubview:infoLabel];
    
    if (update && updatePath.row == row) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"结算中心_虚线.png"]];
        lineImage.frame = CGRectMake(10, imageY + imageH + 5, 300, 2);
        [cell.contentView addSubview:lineImage];
        
        UILabel *instroduceLabel = [[UILabel alloc] init];
        instroduceLabel.backgroundColor = [UIColor clearColor];
        instroduceLabel.textColor = [UIColor grayColor];
        NSString *str = @"周美慧英文名Evelyn，1992年12月15日出生于北京毕业于北京青年政治学院、北京新面孔模特学校。有着“广告新宠”、“时尚嫩模”之称，周美慧凭借清纯可爱的面孔、高挑的身材成功进入模特圈，获得众多网友喜爱和追捧，并成为各大导演看好的新星。";
        instroduceLabel.text = str;
        instroduceLabel.numberOfLines = 0;
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
        instroduceLabel.font = font;
        
        CGSize constraint = CGSizeMake(300,2000);
        CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping | NSLineBreakByWordWrapping];
        //因为上下个空出五个点出来
        instroduceLabel.frame = CGRectMake(10, lineImage.frame.origin.y + lineImage.frame.size.height + 5, 300, size.height);
        [cell.contentView addSubview:instroduceLabel];
        
        UIButton *arrowButton = [[UIButton alloc] init];
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];
        [arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        arrowButton.frame = CGRectMake(self.view.bounds.size.width - 50, size.height + 25 + 80.0 - 30, 25.0f, 20.0);
        [cell.contentView addSubview:arrowButton];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (update && updatePath.row == row) {
        NSString *str = @"车啊换京哈加合法哈就好放假啊胡椒粉哈酒分哈就好放假啊回复哈减肥换金啊换放假啊回复就爱好减肥哈酒哈酒哈酒阿娇快放假阿克江发卡机开发机开发机阿卡积分卡积分卡尽快放假啊金卡积分卡";
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
        
        
        CGSize constraint = CGSizeMake(300,2000);
        CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping | NSLineBreakByWordWrapping];
        return size.height + 25 + 90.0f;
    }
    return 80.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    if (!update || indexPath.row != updatePath.row) {
        update = YES;
        updatePath = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
    
    
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
