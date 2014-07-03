//
//  Dao+syncFriendCategory.m
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao+syncFriendCategory.h"

@implementation Dao (syncFriendCategory)

//***********************************同步请求好友列表*******************************************//
-(NSDictionary *)requestFriendListWith:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.getfriend];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    NSArray *friendArray = [myDic objectForKey:@"items"];
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    if ([friendArray count] != 0) {
        sysModel.user.friendList = [[NSMutableArray alloc] initWithCapacity:0];
        sysModel.listContent = [[NSMutableArray alloc] initWithCapacity:0];
    }
    for (NSDictionary *friendDic in friendArray) {
        TKAddressBook *book = [[TKAddressBook alloc] init];
        NSString *dateline = [friendDic objectForKey:@"dateline"];
        if (dateline == nil || [dateline isMemberOfClass:[NSNull class]]) {
            dateline = @"";
        }
        book.fuid = dateline;
        
        NSString *fuid = [friendDic objectForKey:@"fuid"];
        if (fuid == nil || [fuid isMemberOfClass:[NSNull class]]) {
            fuid = @"0";
        }
        book.fuid = fuid;
        
        NSString *fusername = [friendDic objectForKey:@"fusername"];
        if (fusername == nil || [fusername isMemberOfClass:[NSNull class]]) {
            fusername = @"匿名";
        }
        book.fusername = fusername;
        book.name = fusername;
        
        NSString *fuuid = [friendDic objectForKey:@"fuuid"];
        if (fuuid == nil || [fuuid isMemberOfClass:[NSNull class]]) {
            fuuid = @"0";
        }
        book.fuuid = fuuid;
        
        NSString *gid = [friendDic objectForKey:@"gid"];
        if (gid == nil || [gid isMemberOfClass:[NSNull class]]) {
            gid = @"0";
        }
        book.gid = gid;
        
        NSString *note = [friendDic objectForKey:@"note"];
        if (note == nil || [note isMemberOfClass:[NSNull class]]) {
            note = @"匿名";
        }
        book.note = note;
        
        NSString *num = [friendDic objectForKey:@"num"];
        if (num == nil || [num isMemberOfClass:[NSNull class]]) {
            num = @"0";
        }
        book.num = num;
        
        
        [sysModel.user.friendList addObject:book];
    }
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *addressBookTemp = sysModel.user.friendList;
    for (TKAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (TKAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        NSMutableArray *mutablesortedSection = [[NSMutableArray alloc] initWithArray:sortedSection];
        
        [sysModel.listContent addObject:mutablesortedSection];
    }
    
    NSString *fuid = [NSString stringWithFormat:@"%d",sysModel.user.uid];
    NSDictionary *addDic = [[NSDictionary alloc] initWithObjectsAndKeys:fuid,@"uid", nil];
    [self requestAddFriendListWith:addDic];
    
    return nil;
}

-(void)requestAddFriendListWith:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.addfriendlist];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    NSArray *friendArray = [myDic objectForKey:@"items"];
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    sysModel.user.requestFriendList = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *friendDic in friendArray) {
        TKAddressBook *book = [[TKAddressBook alloc] init];
        NSString *dateline = [friendDic objectForKey:@"dateline"];
        if (dateline == nil || [dateline isMemberOfClass:[NSNull class]]) {
            dateline = @"";
        }
        book.fuid = dateline;
        
        NSString *fuid = [friendDic objectForKey:@"fuid"];
        if (fuid == nil || [fuid isMemberOfClass:[NSNull class]]) {
            fuid = @"0";
        }
        book.fuid = fuid;
        
        NSString *fusername = [friendDic objectForKey:@"fusername"];
        if (fusername == nil || [fusername isMemberOfClass:[NSNull class]]) {
            fusername = @"匿名";
        }
        book.fusername = fusername;
        
        NSString *fuuid = [friendDic objectForKey:@"fuuid"];
        if (fuuid == nil || [fuuid isMemberOfClass:[NSNull class]]) {
            fuuid = @"0";
        }
        book.fuuid = fuuid;
        
        NSString *gid = [friendDic objectForKey:@"gid"];
        if (gid == nil || [gid isMemberOfClass:[NSNull class]]) {
            gid = @"0";
        }
        book.fusername = fusername;
        book.name = fusername;
        
        NSString *note = [friendDic objectForKey:@"note"];
        if (note == nil || [note isMemberOfClass:[NSNull class]]) {
            note = @"";
        }
        book.note = note;
        
        NSString *num = [friendDic objectForKey:@"num"];
        if (num == nil || [num isMemberOfClass:[NSNull class]]) {
            num = @"0";
        }
        book.num = num;
        
        [sysModel.user.requestFriendList addObject:book];
    }
}

-(NSDictionary *)agreeRequestAddFriend:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.acceptfriend];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
    
}

-(NSDictionary *)requestToAddFriend:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.addfriend];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
    
}

-(NSDictionary *)getFriendInfo:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.getInfoOther];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
}

-(NSDictionary *)deleteFriendWithDict:(NSDictionary *)dict
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.deletefriend];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
}

@end
