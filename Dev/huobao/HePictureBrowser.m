//
//  HeJoinView.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HePictureBrowser.h"

@interface HePictureBrowser ()
@property(strong,nonatomic)IBOutlet UIScrollView *picScrollView;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *subPictureArray;

@end

@implementation HePictureBrowser
@synthesize picScrollView;
@synthesize pictureArray;
@synthesize subPictureArray;

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
        label.text = @"照片墙";
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
    
    pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    subPictureArray =  [[NSMutableArray alloc] initWithCapacity:0];
    
}

-(void)initView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    picScrollView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self addPic];
    
    
}

-(void)addPic
{
    int row = 0;
    int column = 0;
    
    int num = 20;
    UIImage *placeholder = [UIImage imageNamed:@"huodemo.jpg"];
    for (int i = 0; i < num; i++) {

        UIImageView *asyncImage = [[UIImageView alloc] init];
        [picScrollView addSubview:asyncImage];
        
        
        
        if (row<2) {
            asyncImage.frame = CGRectMake(10+row*155, 10 + column*90, 145, 70);
            row++;
            
        }
        else{
            column++;
            row = 0;
            asyncImage.frame = CGRectMake(10+row*155, 10 + column*90, 145, 70);
            row++;
        }
        
        
        [asyncImage setImageURLStr:nil placeholder:placeholder];
        // 事件监听
        asyncImage.tag = i;
        asyncImage.userInteractionEnabled = YES;
        asyncImage.layer.cornerRadius = 2.0f;
        asyncImage.layer.masksToBounds = YES;
        asyncImage.layer.borderWidth = 0;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        [asyncImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        asyncImage.clipsToBounds = YES;
        asyncImage.contentMode = UIViewContentModeScaleAspectFill;
        

        
        
    }
    int numColumn = column + 1;
    CGFloat height = 70*numColumn + 40 + (numColumn-1)*20;
    picScrollView.contentSize = CGSizeMake(320, height);
    
    
}

-(void)backTolastView:(UIGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapImage:(UIGestureRecognizer *)tap
{
    int count = 20;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *urls = @"http://365hh.cn//Upload/s_20140327153708201403270018571434.jpg";
        NSString *url = [urls stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = picScrollView.subviews[i]; // 来源于哪个UIImageView
        
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
