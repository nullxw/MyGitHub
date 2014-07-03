//
//  Dao+asyncFriendCategory.h
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao.h"
#import "ASIHttpRequest/ASIHTTPRequest.h"
#import "JSONKit.h"

@interface Dao (asyncFriendCategory)

-(void)asyncRequestFriendListWith:(NSDictionary *)dict;
-(void)asyncAgreeRequestAddFriend:(NSDictionary *)dict;
-(void)asyncRequestToAddFriend:(NSDictionary *)dict;
-(void)asyncGetFriendInfo:(NSDictionary *)dict;
-(void)asyncRequestAddFriendListWith:(NSDictionary *)dict;

@end
