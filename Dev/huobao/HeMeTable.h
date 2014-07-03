//
//  HeMeTable.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "HeUser.h"
#import "MRZoomScrollView.h"
#import "AsynImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "Dao.h"

#define isAutoDownloadKey   @"isAutoDownLoad"
#define isPushKey           @"isPush"
#define isAutoLoginKey      @"isAutoLogin"

#define isLoginOutKey       @"isLoginOutKey"

#define ACCOUNT_KEY         @"accountKey"
#define PASSWORD_KEY        @"passwordKey"

@protocol HeMeTableSelectProtocol <NSObject>

-(void)selectTableWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface HeMeTable : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSArray *myData_Source;
@property(assign,nonatomic)id<HeMeTableSelectProtocol>selectDelegate;
@property(strong,nonatomic)HeUser *user;
@property(strong,nonatomic)AsynImageView *user_headImage;

@end
