//
//  HeAddFriendView.h
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"
#import "CPTextViewPlaceholder.h"
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"
#import "TKAddressBook.h"
#import "Dao.h"
#import "MBProgressHUD.h"
#import "Dao.h"
#import "HeSysbsModel.h"
#import "Dao+syncFriendCategory.h"

@interface HeAddFriendView : UIViewController<UITextViewDelegate,MBProgressHUDDelegate>

@property(strong,nonatomic)NSDictionary *userDic;

-(id)initWithBook:(TKAddressBook *)book;
-(id)initWithuuid:(NSString *)_uuid;
-(id)initWithDict:(NSDictionary *)dic;

@end
