//
//  HeUser.h
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynImageView.h"

@interface HeUser : NSObject

@property(strong,nonatomic)AsynImageView *userImage;//用户头像
@property(assign,nonatomic)int sex;  //1.男   2.女
@property(strong,nonatomic)NSString *nichen;//昵称
@property(strong,nonatomic)NSString *sign;//签名
@property(strong,nonatomic)NSString *address;//地址
@property(strong,nonatomic)NSString *phone;//电话
@property(strong,nonatomic)NSString *email;//邮箱
@property(strong,nonatomic)NSString *sessionKey;
@property(strong,nonatomic)NSString *birthday;
@property(strong,nonatomic)NSString *summary;
@property(strong,nonatomic)NSString *uuid;
@property(strong,nonatomic)NSString *passport;
@property(strong,nonatomic)NSString *jifen;
@property(assign,nonatomic)int stateID;//状态ID
@property(assign,nonatomic)int statue;//身份 1.vip 2.非vip
@property(assign,nonatomic)int uid;
@property(strong,nonatomic)NSMutableArray *friendList;
@property(strong,nonatomic)NSMutableArray *requestFriendList;
@property(strong,nonatomic)NSString *profile;
@property(strong,nonatomic)NSDictionary *countDic;

@end
