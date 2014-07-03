//
//  HeHuoViewController.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "UIButton+Bootstrap.h"
#import "AsynImageView.h"
#import "UIImage+ImageEffects.h"
#import "HeSubscribeViewController.h"
#import "HeHuoTableViewCell.h"
#import "Dao.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"
#import "Dao+baoCategory.h"
#import "Dao+asyncFriendCategory.h"


#define isAutoDownloadKey   @"isAutoDownLoad"
#define isPushKey           @"isPush"
#define isAutoLoginKey      @"isAutoLogin"

#define isLoginOutKey       @"isLoginOutKey"

#define ACCOUNT_KEY         @"accountKey"
#define PASSWORD_KEY        @"passwordKey"

@interface HeHuoViewController : UIViewController<ZBarReaderDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,DaoProtocol,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate,DaoProtocol>
{
    BOOL isAutoLogin;
    BOOL isLogout;
    int updateOption;  //1:上拉刷新   2:下拉加载
    
    BOOL _reloading;
    BOOL changeOffset;
}

@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSString *dateline;


@end
