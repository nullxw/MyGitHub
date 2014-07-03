//
//  Dao.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeSysbsModel.h"
#import "AsynImageView.h"
#import "TKAddressBook.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"

@protocol DaoProtocol <NSObject>

@optional
-(void)requestSucceedWithStateID:(int)stateid withErrorStirng:(NSString *)errorString;
-(void)requestSucceedWithDic:(NSDictionary *)receiveDic;

@end

@interface Dao : NSObject


@property  BOOL reachbility;
@property(assign,nonatomic)id<DaoProtocol>daoDelegate;
@property(strong,nonatomic)NSString *imageBaseUrl;
//内网
@property(strong,nonatomic)NSString *baseUrl;
//获取验证码
@property(strong,nonatomic)NSString *verifyCode;
//验证码验证
@property(strong,nonatomic)NSString *validate;
//填写信息注册
@property(strong,nonatomic)NSString *registerStr;
//登录
@property(strong,nonatomic)NSString *login;
//个人信息
@property(strong,nonatomic)NSString *getInfo;
//好友列表 A的好友列表
@property(strong,nonatomic)NSString *getfriend;
//删除好友
@property(strong,nonatomic)NSString *deletefriend;
//请求加好友 A请求B为好友
@property(strong,nonatomic)NSString *addfriend;
//请求好友列表 B的被请求列表
@property(strong,nonatomic)NSString *addfriendlist;
//同意加好友 B同意A的请求加好友
@property(strong,nonatomic)NSString *acceptfriend;
//获取好友详情
@property(strong,nonatomic)NSString *getInfoOther;
//下载活的url
@property(strong,nonatomic)NSString *huoUrl;
//下载宝的url
@property(strong,nonatomic)NSString *baoUrl;
//参加活动的url
@property(strong,nonatomic)NSString *joinUrl;
//积分历史
@property(strong,nonatomic)NSString *historyCreditUrl;
//获取活箱
@property(strong,nonatomic)NSString *huo_caseUrl;
//获取宝箱
@property(strong,nonatomic)NSString *bao_caseUrl;
//上传头像
@property(strong,nonatomic)NSString *uploadProfileurl;
@property(strong,nonatomic)NSMutableData *receiveData;

-(void)loginRequestWithdict:(NSDictionary *)dict;
+(id)sharedDao;

-(NSDictionary *)registWithPhone:(NSDictionary *)dict;
-(NSDictionary *)validateWithCode:(NSDictionary *)dict;
-(NSDictionary *)registerWithDic:(NSDictionary *)dict;

//异步POST的公共方法
-(void)requestwithDataRequest:(ASIFormDataRequest *)reqForm dict:(NSDictionary *)dict;
//同步POST公共方法
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict;
//图片异步POST的公共方法
-(void)requestwithPicDataRequest:(ASIFormDataRequest *)reqForm dict:(NSDictionary *)dict;
@end
