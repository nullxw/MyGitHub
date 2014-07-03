//
//  Dao+baoCategory.m
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao+baoCategory.h"

@implementation Dao (baoCategory)

-(void)asyncHuoListWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.huoUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(getHuoListFaild:)];
    [reqForm setDidFinishSelector:@selector(getHuoListSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncBaoListWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.baoUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(getHuoListFaild:)];
    [reqForm setDidFinishSelector:@selector(getHuoListSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}
-(void)getHuoListFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)getHuoListSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    NSDictionary *myDic = [receiveString objectFromJSONString];
    NSLog(@"myDic = %@",myDic);
    [self.daoDelegate requestSucceedWithDic:myDic];
}

-(void)asyncJoinActivityWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@",self.joinUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(joinActivityFaild:)];
    [reqForm setDidFinishSelector:@selector(joinActivitySucceed:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)joinActivityFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    [self.daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

-(void)joinActivitySucceed:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *myDic = [receiveString objectFromJSONString];
    NSLog(@"myDic = %@",myDic);
    [self.daoDelegate requestSucceedWithDic:myDic];
}

-(void)asyncgetCreditHistoryWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.historyCreditUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(joinActivityFaild:)];
    [reqForm setDidFinishSelector:@selector(joinActivitySucceed:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncgetHuo_caseWith:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.huo_caseUrl];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(joinActivityFaild:)];
    [reqForm setDidFinishSelector:@selector(joinActivitySucceed:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}

-(void)asyncUploadProfile:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:nil];//-1代表当前网络不可用
        return;
    }
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.uploadProfileurl];
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
//    [reqForm setDidFailSelector:@selector(joinActivityFaild:)];
//    [reqForm setDidFinishSelector:@selector(joinActivitySucceed:)];
    [self requestwithPicDataRequest:nil dict:(NSDictionary *)dict];
}



@end
