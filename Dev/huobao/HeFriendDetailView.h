//
//  HeFriendDetailView.h
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAddressBook.h"
#import "UIButton+Bootstrap.h"
#import "Dao.h"
#import "HeSysbsModel.h"
#import "JSONKit/JSONKit.h"
#import "MBProgressHUD.h"

@interface HeFriendDetailView : UIViewController<MBProgressHUDDelegate>

@property(strong,nonatomic)NSString *uuid;
@property(assign,nonatomic)int loadSucceedFlag;
@property(strong,nonatomic)NSDictionary *userDic;

-(id)initWithBook:(TKAddressBook *)book;
-(id)initWithDict:(NSDictionary *)dic;
-(id)initWithuuid:(NSString *)_uuid;

@end
