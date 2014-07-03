//
//  HeMeTable.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeMeTable.h"
#import "AsynImageView.h"
#import "HeAppDelegate.h"
#import "MRZoomScrollView.h"
#import "HeUser.h"
#import "HeSysbsModel.h"


@interface HeMeTable ()
@property(strong,nonatomic)UIButton *signOutButton;
@property(strong,nonatomic)NSArray *picArray;



@end

@implementation HeMeTable
@synthesize signOutButton;
@synthesize myData_Source;
@synthesize picArray;
@synthesize user_headImage;
@synthesize selectDelegate;
@synthesize user;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)mystyle
{
    self = [super initWithFrame:frame style:mystyle];
    if (self) {
        // Initialization code
        [self initControl];
        [self initTable];
        HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
        self.user = sysModel.user;
        
    }
    return self;
}


-(void)initControl
{
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *array2 = [[NSArray alloc] initWithObjects:@"宝箱",@"活箱",@"摇号单", nil];
    NSArray *array3 = [[NSArray alloc] initWithObjects:@"积分历史", nil];
    self.myData_Source = [[NSArray alloc] initWithObjects:array1,array2,array3, nil];
}

-(void)initTable
{
    self.backgroundView = nil;
    self.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    self.delegate = self;
    self.dataSource = self;
    
    self.signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signOutButton.frame = CGRectMake(40, 0, 240, 40);
    [signOutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [signOutButton dangerStyle];
    [signOutButton addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 250)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    [tableFooterView addSubview:signOutButton];
    self.tableFooterView = tableFooterView;
    
}


-(void)signOut:(id)sender
{
    NSLog(@"注销账号");
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    sysModel.user = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isLoginOutKey];
    [userDefaults setObject:@"" forKey:ACCOUNT_KEY];
    [userDefaults setObject:@"" forKey:PASSWORD_KEY];
    [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isAutoLoginKey];
    [userDefaults synchronize];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"loginSucceed" object:nil userInfo:nil];
    
    [self.selectDelegate selectTableWithIndexPath:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [myData_Source count];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    cell.textLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    
    @try {
        NSString *string = [[myData_Source objectAtIndex:section] objectAtIndex:row];
        NSString *iconNameStr = [NSString stringWithFormat:@"%@.png",string];
        cell.textLabel.text = [NSString stringWithFormat:@"        %@",string];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconNameStr]];
        icon.frame = CGRectMake(5, 7.5, 30, 30);
        [cell.contentView addSubview:icon];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    switch (section) {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *userHead_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像框.png"]];
            userHead_bg.frame = CGRectMake(10, 10, 80, 80);
            userHead_bg.userInteractionEnabled = YES;
            [cell.contentView addSubview:userHead_bg];
            HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
            
            if (user_headImage == nil) {
                
                user_headImage = [[AsynImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
                //图片还没记载完成的时候默认的加载图片
                
                user_headImage.placeholderImage = sysModel.user.userImage.placeholderImage;
                
                /****设置图片的边角为圆角****/
                user_headImage.layer.cornerRadius = 5;
                user_headImage.layer.masksToBounds = YES;
                user_headImage.layer.borderWidth = 0.0f;
                user_headImage.layer.borderColor = [[UIColor clearColor] CGColor];
                UITapGestureRecognizer *tapPicGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargePicture:)];
                tapPicGes.numberOfTapsRequired = 1;
                tapPicGes.numberOfTouchesRequired = 1;
                user_headImage.userInteractionEnabled = YES;
                [user_headImage addGestureRecognizer:tapPicGes];
            }
            Dao *shareDao = [Dao sharedDao];
            NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,sysModel.user.uuid];
            user_headImage.tag = -1;
            user_headImage.imageURL = imageUrl;
            
//            [user_headImage setImageURL:imageUrl];
            [userHead_bg addSubview:user_headImage];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = user.nichen;
            
            if (user.nichen == nil || [user.nichen isEqualToString:@""]) {
                nameLabel.text = @"匿名";
            }
            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16.5f];
            CGSize labelSize = [nameLabel.text sizeWithFont:nameLabel.font
                                
                                      constrainedToSize:CGSizeMake(FLT_MAX,FLT_MAX)
                                
                                          lineBreakMode:NSLineBreakByWordWrapping];
            nameLabel.frame = CGRectMake(userHead_bg.frame.origin.x + userHead_bg.frame.size.width + 10.0, 10, labelSize.width, 20.0);
            [cell.contentView addSubview:nameLabel];
            
            int sex = user.sex;
            UIImageView *sexIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"女.png"]];
            if (sex == 1) {
                sexIcon.image = [UIImage imageNamed:@"男.png"];
            }
            sexIcon.frame = CGRectMake(nameLabel.frame.size.width + nameLabel.frame.origin.x + 10, 10, 20.0f, 20.0f);
            [cell.contentView addSubview:sexIcon];
            
            UILabel *signLabel = [[UILabel alloc] init];
            signLabel.backgroundColor = [UIColor clearColor];
            signLabel.textColor = [UIColor grayColor];
            signLabel.text = user.sign;
            if (signLabel.text == nil || [signLabel.text isEqualToString:@""]) {
                signLabel.text = @"暂无签名";
            }
            signLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            signLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 5, 200, 40);
            signLabel.numberOfLines = 2;
            [cell.contentView addSubview:signLabel];
            
            UILabel *jifenLabel = [[UILabel alloc] init];
            jifenLabel.backgroundColor = [UIColor clearColor];
            jifenLabel.textColor = [UIColor redColor];
            jifenLabel.text = [NSString stringWithFormat:@"%@积分",user.jifen];
            jifenLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            jifenLabel.frame = CGRectMake(cell.contentView.bounds.size.width - 110, 70, 100, 20);
            jifenLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:jifenLabel];
            
            break;
        }
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            switch (row) {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    break;
                }
                case 2:
                {
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (row) {
                case 0:
                {
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            return 100.0f;
            break;
        }
        case 1:
        {
            return 45.0;
            break;
        }
        case 2:
        {
            return 45.0;
            break;
        }
        default:
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectDelegate selectTableWithIndexPath:indexPath];
}


//点击图片放大
-(void)enlargePicture:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIGestureRecognizer *ges = (UIGestureRecognizer*)sender;
    AsynImageView *originalImage = (AsynImageView*)ges.view;
    HeAppDelegate *delegate = (HeAppDelegate*)[[UIApplication sharedApplication] delegate];
    CGRect superFrame = originalImage.superview.frame;
    NSLog(@"%f,%f",superFrame.origin.x,superFrame.origin.y);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    UIScreen *mainScreen = [UIScreen mainScreen];
    scrollView.pagingEnabled = YES;
    scrollView.frame = CGRectMake(0, 0, 320,mainScreen.bounds.size.height);
    [scrollView setContentSize:CGSizeMake(320, mainScreen.bounds.size.height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPic:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:tap];
    
    MRZoomScrollView *zoomScrollView = [[MRZoomScrollView alloc] initWithAsyImageFrame:self.superview.bounds];
    CGRect frame = scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    zoomScrollView.frame = frame;
    zoomScrollView.showsHorizontalScrollIndicator = NO;
    zoomScrollView.showsVerticalScrollIndicator = NO;
    zoomScrollView.backgroundColor = [UIColor blackColor];
    zoomScrollView.imageView.layer.borderWidth = 0.0;
    zoomScrollView.imageView.backgroundColor = [UIColor blackColor];
    zoomScrollView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    zoomScrollView.imageView.autoresizesSubviews = YES;
    zoomScrollView.imageView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    zoomScrollView.imageView.frame = frame;
    zoomScrollView.imageView.imageURL = self.user_headImage.imageURL;
//    //demo测试
//    zoomScrollView.imageView.image = self.user_headImage.placeholderImage;
    
    [scrollView addSubview:zoomScrollView];
    [delegate.window addSubview:scrollView];
    
    [self shakeToShow:scrollView];//放大过程中的动画
 
    //    [imgView release];
    
    //动画效果
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];//动画时间长度，单位秒，浮点数
    [self.superview exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView setAnimationDelegate:scrollView];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

//*************放大过程中出现的缓慢动画*************
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void)dismissPic:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIScrollView *image = (UIScrollView*)tap.view;
    [image removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
