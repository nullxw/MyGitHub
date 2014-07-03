//
//  HeSubscribeViewController.m
//  huobao
//
//  Created by Tony He on 14-5-23.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeSubscribeViewController.h"
#import "AsynImageView.h"
#import "UIButton+Bootstrap.h"

@interface HeSubscribeViewController ()
@property(strong,nonatomic)IBOutlet UITableView *myTableview;
@property(strong,nonatomic)AsynImageView *headerImage;
@property(strong,nonatomic)AsynImageView *headerBGImage;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *downloadedArray;
@property(strong,nonatomic)UIView *bgView;
@property(strong,nonatomic)UILabel *simpleLabel;
@property(strong,nonatomic)UIButton *logoButton;

@end

@implementation HeSubscribeViewController
@synthesize myTableview;
@synthesize pictureArray = _pictureArray;
@synthesize downloadedArray = _downloadedArray;
@synthesize headerImage;
@synthesize headerBGImage;
@synthesize simpleLabel;
@synthesize bgView;
@synthesize logoButton;
@synthesize scribeDic;

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

-(id)initWithDic:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.scribeDic = [[NSDictionary alloc] initWithDictionary:dict];
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
    update = NO;
    
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
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 220.0f);
  
    headerBGImage = [[AsynImageView alloc] init];
    headerBGImage.placeholderImage = [UIImage imageNamed:@"假日广场.jpg"];
    headerBGImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, 120.0f);
    headerBGImage.layer.borderColor = [[UIColor clearColor] CGColor];
    headerBGImage.layer.borderWidth = 0;
    [bgView addSubview:headerBGImage];
    
    
    
    UIView *lucencyView = [[UIView alloc] init];
    
    lucencyView.layer.borderWidth = 0.0f;
    lucencyView.layer.borderColor = [[UIColor clearColor] CGColor];
    lucencyView.layer.masksToBounds = YES;
    lucencyView.frame = CGRectMake(0, 0, self.view.bounds.size.width, headerBGImage.bounds.size.height);
    lucencyView.backgroundColor = [UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:0.5];
    [bgView addSubview:lucencyView];
    
    logoButton = [[UIButton alloc] init];
    logoButton.frame = CGRectMake(self.view.bounds.size.width - 70.0, 20, 60.0, 20);
    [logoButton infoStyle];
    [logoButton setTitle:@"订阅" forState:UIControlStateNormal];
    [bgView addSubview:logoButton];
    logoButton.enabled = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    titleLabel.text = @"假日广场";
    titleLabel.frame = CGRectMake(10.0f, 20.0, 200, 20);
    [lucencyView addSubview:titleLabel];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = @"假日广场位于中山要道兴中道与孙文东路交汇处，地理、交通得天独厚。紧邻市人大和市政府等重要机构，高级商业大楼和豪华住宅林立两旁，具备罕有标志性地利与极高的商业价值";
    introduceLabel.backgroundColor = [UIColor clearColor];
    introduceLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    introduceLabel.numberOfLines = 4;
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.frame = CGRectMake(10.0, 45.0, 300, 70.0);
    [lucencyView addSubview:introduceLabel];
    
//    headerImage = [[AsynImageView alloc] init];
//    headerImage.placeholderImage = [UIImage imageNamed:@"假日广场图标.jpg"];
//    headerImage.layer.cornerRadius = 5.0f;
//    headerImage.layer.borderColor = [[UIColor clearColor] CGColor];
//    headerImage.layer.borderWidth = 0;
//    headerImage.layer.masksToBounds = YES;
//    headerImage.frame = CGRectMake(10, 22, 60, 60);
//    [bgView addSubview:headerImage];
    
    simpleLabel = [[UILabel alloc] init];
    simpleLabel.backgroundColor = [UIColor clearColor];
    simpleLabel.numberOfLines = 3;
    simpleLabel.textColor = [UIColor grayColor];
    simpleLabel.frame = CGRectMake(10, headerBGImage.frame.size.height + 10, 300, 60.0);
    simpleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString *infoString = @"中山假日广场坐落于中山市城区兴中道与孙文路交汇的黄金轴线，是中山市的核心地段，全球各大时尚服饰和家居精品，汇聚于此，一应俱全。玻光喷泉的水流经特殊装置整流后喷出，形成似玻璃棒般的弧形水柱，喷头内部可带灯，所以喷出的水柱有明显的光亮。喷泉具有光源反射效果的水流沿轨迹喷向半空，挂起一道幽雅的弧线，形如拱门。 波光泉可装在人行道上，行人从拱门过而衣衫不湿。";
    simpleLabel.text = infoString;
    [bgView addSubview:simpleLabel];
    
    UIButton *arrowButton = [[UIButton alloc] init];
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateNormal];
    arrowButton.tag = 1;
    [arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    arrowButton.frame = CGRectMake((self.view.bounds.size.width - 25)/2, 190.0, 25.0f, 20.0);
    [bgView addSubview:arrowButton];
    myTableview.tableHeaderView = bgView;
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)arrowButtonClick:(UIButton *)sender
{
    [sender removeFromSuperview];
    sender.hidden = YES;
    switch (sender.tag) {
        
        case 1:
        {
            //展开
            NSString *infoString = @"中山假日广场坐落于中山市城区兴中道与孙文路交汇的黄金轴线，是中山市的核心地段，全球各大时尚服饰和家居精品，汇聚于此，一应俱全。玻光喷泉的水流经特殊装置整流后喷出，形成似玻璃棒般的弧形水柱，喷头内部可带灯，所以喷出的水柱有明显的光亮。喷泉具有光源反射效果的水流沿轨迹喷向半空，挂起一道幽雅的弧线，形如拱门。 波光泉可装在人行道上，行人从拱门过而衣衫不湿。";
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
            CGSize constraint = CGSizeMake(300,2000);
            CGSize size = [infoString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping | NSLineBreakByWordWrapping];
            simpleLabel.numberOfLines = 0;
            CGRect frame = simpleLabel.frame;
            frame.size.height = 120.0 + size.height + 50;
            
            
            [UIView animateWithDuration:.5 animations:^{
                simpleLabel.frame = CGRectMake(10, headerBGImage.frame.size.height + 10, 300, size.height + 20);
                bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, frame.size.height);
                myTableview.tableHeaderView = bgView;
                
            } completion:^(BOOL finished) {
                NSLog(@"finish");
                //NSLog(@"tapsetenable");
                UIButton *arrowButton = [[UIButton alloc] init];
                [arrowButton setBackgroundImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];
                arrowButton.tag = 2;
                [arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                arrowButton.frame = CGRectMake((self.view.bounds.size.width - 18)/2, frame.size.height - 20, 18.0f, 15.0);
                [bgView addSubview:arrowButton];
                
            }];
            
            [UIView setAnimationsEnabled:YES];
            
            break;
        }
        case 2:
        {
            //收缩
            [UIView animateWithDuration:.5 animations:^{
                simpleLabel.frame = CGRectMake(10, headerBGImage.frame.size.height + 10, 300, 60.0);
                bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 220.0f);
                simpleLabel.numberOfLines = 3;
                myTableview.tableHeaderView = bgView;
                
            } completion:^(BOOL finished) {
                NSLog(@"finish");
                //NSLog(@"tapsetenable");
                UIButton *arrowButton = [[UIButton alloc] init];
                [arrowButton setBackgroundImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateNormal];
                arrowButton.tag = 1;
                [arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                arrowButton.frame = CGRectMake((self.view.bounds.size.width - 25)/2, 190.0, 25.0f, 20.0);
                [bgView addSubview:arrowButton];
                
            }];
            
            [UIView setAnimationsEnabled:YES];
            break;
        }
        default:
            break;
    }

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"HeSubscribeCell";
    HeSubscribeCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[HeSubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    HeActivityDetailView *activityDetailView = [[HeActivityDetailView alloc] initWithActivityDict:scribeDic];
    activityDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityDetailView animated:YES];
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

@end
