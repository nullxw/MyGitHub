//
//  HeYaoHaoListView.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeYaoHaoListView.h"
#import "AsynImageView.h"

@interface HeYaoHaoListView ()
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;

@end

@implementation HeYaoHaoListView
@synthesize yaoHaoTble;
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
        label.text = @"摇号单";
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
    
    self.pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.downloadedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}

-(void)initView
{
    self.yaoHaoTble.backgroundView = nil;
    
    
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"HeYaoHaoCell";
	HeYaoHaoCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[HeYaoHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    NSInteger row = indexPath.row;
	
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
