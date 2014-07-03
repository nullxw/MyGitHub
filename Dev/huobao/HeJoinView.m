//
//  HeJoinView.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeJoinView.h"

@interface HeJoinView ()
@property(strong,nonatomic)IBOutlet UIScrollView *picScrollView;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSMutableArray *subPictureArray;

@end

@implementation HeJoinView
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
        label.text = @"参加的人";
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
    UIImage *placeholder = [UIImage imageNamed:@"参加的人.jpg"];
    for (int i = 0; i < num; i++) {
        UIImageView *asyncImage = [[UIImageView alloc] init];
        [picScrollView addSubview:asyncImage];
        
        if (row<3) {
            asyncImage.frame = CGRectMake(20+row*100, 10 + column*120, 80, 80);
            row++;
            
        }
        else{
            column++;
            row = 0;
            asyncImage.frame = CGRectMake(20+row*100, 10 + column*120, 80, 80);
            row++;
        }
        
        
        [asyncImage setImageURLStr:nil placeholder:placeholder];
        // 事件监听
        asyncImage.tag = i;
        asyncImage.userInteractionEnabled = YES;
        asyncImage.layer.cornerRadius = 5.0f;
        asyncImage.layer.masksToBounds = YES;
        asyncImage.layer.borderWidth = 0;
        asyncImage.layer.borderColor = [[UIColor clearColor] CGColor];
        [asyncImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        asyncImage.clipsToBounds = YES;
        asyncImage.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = @"小伙伴23";
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        CGRect frame = asyncImage.frame;
        frame.origin.y = frame.origin.y + frame.size.height - 20;
        nameLabel.frame = frame;
        [picScrollView addSubview:nameLabel];
        
        UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        picTap.numberOfTapsRequired = 1;
        picTap.numberOfTouchesRequired = 1;
        [asyncImage addGestureRecognizer:picTap];
        
        
    }
    int numColumn = column + 1;
    CGFloat height = 120*numColumn + 40 + (numColumn-1)*10;
    picScrollView.contentSize = CGSizeMake(320, height);
    
    
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapImage:(id)sender
{
    TKAddressBook *book = [[TKAddressBook alloc] init];
    book.name = @"小伙伴23";
    HeFriendDetailView *friendDetail = [[HeFriendDetailView alloc] initWithBook:book];
    friendDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendDetail animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
