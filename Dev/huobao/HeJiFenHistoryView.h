//
//  HeJiFenHistoryView.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeJiFenHistoryCell.h"
#import "Dao.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableFootView.h"
#import "EGORefreshTableHeaderView.h"
#import "Dao+baoCategory.h"

@interface HeJiFenHistoryView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate,DaoProtocol,MBProgressHUDDelegate>
{
    int updateOption;  //1:上拉刷新   2:下拉加载
    BOOL _reloading;
}

@property(strong,nonatomic)NSMutableArray *jifenHistoryArray;
@property(strong,nonatomic)IBOutlet UITableView *jifenTable;
@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSString *dateline;

@end
