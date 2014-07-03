//
//  HeMyHuoBoxView.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeMyHuoBoxCell.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "Dao+baoCategory.h"


@interface HeMyHuoBoxView : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,DaoProtocol,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate>

{
    int updateOption;  //1:上拉刷新   2:下拉加载
    
    BOOL _reloading;
}

@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSString *dateline;

@property(strong,nonatomic)IBOutlet UITableView *huoBoxTable;

@end
