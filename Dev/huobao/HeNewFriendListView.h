//
//  HeNewFriendListView.h
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "HeNewFriendCell.h"
#import "TKAddressBook.h"
#import "HeSysbsModel.h"
#import "MBProgressHUD.h"
#import "Dao.h"
#import "MBProgressHUD.h"

@protocol updateFriendListProtocol <NSObject>

-(void)updateFriendList;

@end

@interface HeNewFriendListView : UIViewController<UITableViewDataSource,UITableViewDelegate,agreeProtocol,MBProgressHUDDelegate>

@property(strong,nonatomic)id<updateFriendListProtocol>updateListDelegate;
@property(assign,nonatomic)int loadSucceedFlag;

@end
