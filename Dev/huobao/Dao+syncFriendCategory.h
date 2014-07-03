//
//  Dao+syncFriendCategory.h
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao.h"

@interface Dao (syncFriendCategory)

-(NSDictionary *)requestFriendListWith:(NSDictionary *)dict;
-(NSDictionary *)agreeRequestAddFriend:(NSDictionary *)dict;
-(NSDictionary *)requestToAddFriend:(NSDictionary *)dict;
-(NSDictionary *)getFriendInfo:(NSDictionary *)dict;
-(void)requestAddFriendListWith:(NSDictionary *)dict;
-(NSDictionary *)deleteFriendWithDict:(NSDictionary *)dict;

@end
