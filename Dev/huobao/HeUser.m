//
//  HeUser.m
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeUser.h"

@implementation HeUser
@synthesize userImage;
@synthesize sex;  //1.男   2.女
@synthesize nichen;
@synthesize sign;//签名
@synthesize address;
@synthesize phone;
@synthesize email;
@synthesize sessionKey;
@synthesize birthday;
@synthesize summary;
@synthesize uuid;
@synthesize passport;
@synthesize stateID;
@synthesize statue;
@synthesize uid;
@synthesize friendList;
@synthesize requestFriendList;
@synthesize profile;
@synthesize jifen;
@synthesize countDic;

-(id)init
{
    self = [super init];
    if (self) {
        self.friendList = [[NSMutableArray alloc] initWithCapacity:0];
        self.requestFriendList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
@end
