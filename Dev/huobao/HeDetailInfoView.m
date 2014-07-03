//
//  HeDetailInfoView.m
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeDetailInfoView.h"
#import "AsynImageView.h"
#import "HeModifyInfoView.h"
#import "HeUser.h"
#import "HeSysbsModel.h"

@interface HeDetailInfoView ()
@property(strong,nonatomic)UITableView *meInfoTable;
@property(strong,nonatomic)NSArray *myData_Source;
@property(strong,nonatomic)AsynImageView *user_headImage;
@property(strong,nonatomic)HeUser *user;

@end

@implementation HeDetailInfoView
@synthesize meInfoTable;
@synthesize myData_Source;
@synthesize user_headImage;
@synthesize user;
@synthesize popToRoot;
@synthesize loadSucceedFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        popToRoot = NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
    [self initView];
}

-(void)initControl
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updataData) name:@"modifyUser" object:nil];
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    self.user = sysModel.user;
    
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
    
    self.myData_Source = [[NSArray alloc] initWithObjects:@"头像",@"昵称",@"性别",@"签名",@"所在地",@"手机",@"邮箱", nil];
}

-(void)updataData
{
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    self.user = sysModel.user;
    [meInfoTable reloadData];
}

-(void)initView
{
    self.meInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    meInfoTable.delegate = self;
    meInfoTable.dataSource = self;
    meInfoTable.backgroundView = nil;
    meInfoTable.backgroundColor = [UIColor whiteColor];
    [self setExtraCellLineHidden:meInfoTable];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 250)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.meInfoTable.tableFooterView = tableFooterView;
    
    [self.view addSubview:meInfoTable];
}


-(void)backTolastView:(id)sender
{
    if (popToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

//图片的点击手势
-(void)modifyPicture:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
    [sheet showInView:self.user_headImage];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
            {
                HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
                sysModel.user.sex = 1;
                user.sex = 1;
                break;
            }
            case 1:{
                HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
                sysModel.user.sex = 2;
                user.sex = 2;
                break;
            }
            case 2:
                //取消
                break;
            default:
                break;
        }
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"modifyUser" object:self];
        
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            [self pickerPhotoLibrary];
            break;
        }
        case 1:{
            //查看大图
            [self pickerCamer];
            break;
        }
        case 2:
            //取消
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark ImagePicker method
//从相册中打开照片选择画面(图片库)：UIImagePickerControllerSourceTypePhotoLibrary
//启动摄像头打开照片摄影画面(照相机)：UIImagePickerControllerSourceTypeCamera

//按下相机触发事件
-(void)pickerCamer
{
    //照相机类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断属性值是否可用
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        //UIImagePickerController是UINavigationController的子类
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        //设置可以编辑
        imagePicker.allowsEditing = YES;
        //设置类型为照相机
        imagePicker.sourceType = sourceType;
        //进入照相机画面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)uploadProfile
{
    Dao *shareDao = [Dao sharedDao];
    shareDao.daoDelegate = self;

//    NSData *pictureData = UIImageJPEGRepresentation(user_headImage.image, 0.8);
//    NSData *base64AudioData = [GTMBase64 encodeData:pictureData];
    UIImage *profile = user_headImage.image;
    
    
    HeSysbsModel *model = [HeSysbsModel getSysbsModel];
    NSString *uuid  = model.user.uuid;
    self.loadSucceedFlag = 0;
//    [self showLoadLabel:@"上传头像"];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:profile,@"profile",uuid,@"uuid", nil];
    [shareDao asyncUploadProfile:dic];
}

-(void)requestSucceedWithDic:(NSDictionary *)receiveDic
{
    self.loadSucceedFlag = 1;
    NSString *stateStr = [receiveDic objectForKey:@"state"];
    if (stateStr == nil || [stateStr isMemberOfClass:[NSNull class]]) {
        stateStr = @"-1";
    }
    int stateid = [stateStr intValue];
    if (stateid != 1) {
        NSString *msg = [receiveDic objectForKey:@"msg"];
        if ([msg isMemberOfClass:[NSString class]]) {
            if ([msg isMemberOfClass:[NSNull class]] || msg == nil) {
                msg = @"加载出错";
            }
            [self showTipLabelWith:msg];
            
        }
        return;
    }
    
    
    [self showTipLabelWith:@"上传头像成功"];
}

//当按下相册按钮时触发事件
-(void)pickerPhotoLibrary
{
    //图片库类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *photoAlbumPicker = [[UIImagePickerController alloc]init];
    photoAlbumPicker.delegate = self;
    photoAlbumPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    //设置可以编辑
    photoAlbumPicker.allowsEditing = YES;
    //设置类型
    photoAlbumPicker.sourceType = sourceType;
    //进入图片库画面
    [self presentViewController:photoAlbumPicker animated:YES completion:nil];
}


#pragma mark -
#pragma mark imagePickerController method
//当拍完照或者选取好照片之后所要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize sizeImage = image.size;
    float a = [self getSize:sizeImage];
    if (a>0) {
        CGSize size = CGSizeMake(sizeImage.width/a, sizeImage.height/a);
        image = [self scaleToSize:image size:size];
    }
    
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    sysModel.user.userImage.placeholderImage = image;
    user_headImage.imageURL = nil;
    user.userImage.placeholderImage = sysModel.user.userImage.placeholderImage;
    user_headImage.placeholderImage = image;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"modifyUser" object:self];
    [user_headImage removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadProfile];
}


//相应取消动作
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(float)getSize:(CGSize)size
{
    float a = size.width/480;
    if (a > 1) {
        return a;
    }
    else
        return -1;
    
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myData_Source count];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    cell.textLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    NSString *string = [self.myData_Source objectAtIndex:row];
    cell.textLabel.text = string;
    switch (row) {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (user_headImage == nil) {
                
                user_headImage = [[AsynImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, 10, 60, 60)];
                //图片还没记载完成的时候默认的加载图片
                user_headImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
                
                /****设置图片的边角为圆角****/
                user_headImage.layer.cornerRadius = 5;
                user_headImage.layer.masksToBounds = YES;
                user_headImage.layer.borderWidth = 0.0f;
                user_headImage.layer.borderColor = [[UIColor clearColor] CGColor];
                UITapGestureRecognizer *tapPicGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPicture:)];
                tapPicGes.numberOfTapsRequired = 1;
                tapPicGes.numberOfTouchesRequired = 1;
                user_headImage.userInteractionEnabled = YES;
                [user_headImage addGestureRecognizer:tapPicGes];
                
                Dao *shareDao = [Dao sharedDao];
                HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
                NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@/data/profile/%@.png",shareDao.imageBaseUrl,sysModel.user.uuid];
                
                [user_headImage setImageURL:imageUrl];
                
            }
            
            [cell.contentView addSubview:user_headImage];
            break;
        }
        case 1:{
            UILabel *nichenLabel = [[UILabel alloc] init];
            nichenLabel.backgroundColor = [UIColor clearColor];
            nichenLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            nichenLabel.frame = CGRectMake(20, 15.0, self.view.bounds.size.width - 20 - 10, 20);
            nichenLabel.text = user.nichen;
            nichenLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:nichenLabel];
            
            break;
        }
        case 2:{
            //性别
            UILabel *sexLabel = [[UILabel alloc] init];
            sexLabel.backgroundColor = [UIColor clearColor];
            sexLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            sexLabel.frame = CGRectMake(20, 15.0, self.view.bounds.size.width - 20 - 10, 20);
            sexLabel.text = @"女";
            if (user.sex == 1) {
                sexLabel.text = @"男";
            }
            sexLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:sexLabel];
            break;
        }
        case 3:{
            //签名
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
            CGSize constraint = CGSizeMake(220,2000);
            NSString *signString = user.sign;
            CGSize size = [signString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
            
            UILabel *signLabel = [[UILabel alloc] init];
            signLabel.backgroundColor = [UIColor clearColor];
            signLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            signLabel.text = signString;
            signLabel.numberOfLines = 0;
            signLabel.textAlignment = NSTextAlignmentLeft;
            if (size.height + 15 < 50.0) {
                signLabel.frame = CGRectMake(90, 0.0, self.view.bounds.size.width - 100 , 50.0 );
            }
            else{
                signLabel.frame = CGRectMake(90, 0.0, self.view.bounds.size.width - 100, size.height + 15 );
            }
            [cell.contentView addSubview:signLabel];
            break;
        }
        case 4:{
            //所在地
            UILabel *addressLabel = [[UILabel alloc] init];
            addressLabel.backgroundColor = [UIColor clearColor];
            addressLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            addressLabel.frame = CGRectMake(20, 15.0, self.view.bounds.size.width - 20 - 10, 20);
            addressLabel.text = user.address;
            addressLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:addressLabel];
            break;
        }
        case 5:{
            //手机
            UILabel *phoneLabel = [[UILabel alloc] init];
            phoneLabel.backgroundColor = [UIColor clearColor];
            phoneLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            phoneLabel.frame = CGRectMake(20, 15.0, self.view.bounds.size.width - 20 - 10, 20);
            phoneLabel.text = [self hidePhoneNumberWith:user.phone];
            phoneLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phoneLabel];
            break;
        }
        case 6:{
            //邮箱
            UILabel *phoneLabel = [[UILabel alloc] init];
            phoneLabel.backgroundColor = [UIColor clearColor];
            phoneLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            phoneLabel.frame = CGRectMake(20, 15.0, self.view.bounds.size.width - 20 - 10, 20);
            phoneLabel.text = user.email;
            phoneLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phoneLabel];
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
    switch (row) {
        case 0:
            return 80.0f;
            break;
        case 3:{
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
            CGSize constraint = CGSizeMake(220,2000);
            NSString *signString = user.sign;
            CGSize size = [signString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByCharWrapping];
            
            if (size.height + 15 < 50.0) {
                return 50.0;
            }
            return size.height + 15;
            break;
        }
        default:
            break;
    }
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row == 2) {
        //修改性别
        UIActionSheet *sexsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sexsheet.tag = 2;
        [sexsheet showInView:meInfoTable];
        return;
    }
    
    NSString *defaultString = [myData_Source objectAtIndex:row];
    NSString *infoStirng = @"邮箱";
    switch (row) {
        case 1:
        {
            infoStirng = user.nichen;
            break;
        }
        case 3:
        {
            infoStirng = user.sign;
            break;
        }
        case 4:
        {
            infoStirng = user.address;
            break;
        }
        case 5:
        {
            infoStirng = user.phone;
            break;
        }
        case 6:
        {
            infoStirng = user.email;
            break;
        }
        
        default:
            break;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:defaultString,@"defaultInfo",infoStirng,@"info",indexPath,@"indexPath", nil];
    HeModifyInfoView *modifyView = [[HeModifyInfoView alloc] initWithDict:dic];
    modifyView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyView animated:YES];
}

-(NSString *)hidePhoneNumberWith:(NSString*)phone
{
    @try {
        NSRange hideRange = NSMakeRange(3, 5);
        NSString *replaceString = @"*****";
        NSMutableString *mutablePhone = [[NSMutableString alloc] initWithString:phone];
        [mutablePhone replaceCharactersInRange:hideRange withString:replaceString];
        return [NSString stringWithFormat:@"%@",mutablePhone];
    }
    @catch (NSException *exception) {
        return phone;
    }
    @finally {
        
    }
}

-(void)showTipLabelWith:(NSString*)string
{
    if (self.view.window == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = string;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}

-(void)isLoadSucceed
{
    while(self.loadSucceedFlag == 0);
}

-(void)showLoadLabel:(NSString*)string
{
    if (self.view.window == nil) {
        return;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = string;
    [HUD showWhileExecuting:@selector(isLoadSucceed) onTarget:self withObject:nil animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyUser" object:nil];
}

@end
