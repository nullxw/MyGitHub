//
//  Dao+asyncFriendCategory.m
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao+asyncFriendCategory.h"

@implementation Dao (asyncFriendCategory)

-(void)asyncRequestFriendListWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.getfriend];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(getFriendRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(getFriendRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncAgreeRequestAddFriend:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.acceptfriend];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(acceptFriendRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(acceptFriendRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncRequestToAddFriend:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.addfriend];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(addFriendRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(addFriendRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncGetFriendInfo:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.getInfoOther];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(getInfoOtherFriendRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(getInfoOtherFriendRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncRequestAddFriendListWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.addfriendlist];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(getAddFriendListRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(getAddFriendListRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)getFriendRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)getFriendRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    NSDictionary *myDic = [receiveString objectFromJSONString];
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
    [self asyncRequestAddFriendListWith:addDic];
    
}

-(void)acceptFriendRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)acceptFriendRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *receiveDic = [receiveString objectFromJSONString];
    [self.daoDelegate requestSucceedWithDic:receiveDic];
}

-(void)addFriendRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)addFriendRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *receiveDic = [receiveString objectFromJSONString];
    [self.daoDelegate requestSucceedWithDic:receiveDic];
}

-(void)getInfoOtherFriendRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)getInfoOtherFriendRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *receiveDic = [receiveString objectFromJSONString];
    [self.daoDelegate requestSucceedWithDic:receiveDic];
}

-(void)getAddFriendListRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)getAddFriendListRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *myDic = [receiveString objectFromJSONString];
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
    [self.daoDelegate requestSucceedWithDic:nil];
}

@end
