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
#import "HeBaoPiaoDetailView.h"
#import "HeHuoTableViewCell.h"
#import "Dao.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"
#import "Dao+baoCategory.h"


@interface HeBaoViewController : UIViewController<ZBarReaderDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,DaoProtocol,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate,DaoProtocol>
{
    int updateOption;  //1:上拉刷新   2:下拉加载
    BOOL _reloading;
}

@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSString *dateline;


@end
