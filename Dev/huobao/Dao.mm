//
//  Dao.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
static Dao* sharedDaoer;

@implementation Dao
@synthesize reachbility;
@synthesize daoDelegate;
@synthesize imageBaseUrl;
@synthesize baseUrl;
//获取验证码
@synthesize verifyCode;
//验证码验证
@synthesize validate;
//填写信息注册
@synthesize registerStr;
//登录
@synthesize login;
//个人信息
@synthesize getInfo;
//好友列表 A的好友列表
@synthesize getfriend;
//请求加好友 A请求B为好友
@synthesize addfriend;
//请求好友列表 B的被请求列表
@synthesize addfriendlist;
//同意加好友 B同意A的请求加好友
@synthesize acceptfriend;
//获取好友详情
@synthesize getInfoOther;
//下载活的url
@synthesize huoUrl;
@synthesize joinUrl;
@synthesize deletefriend;
@synthesize huo_caseUrl;
@synthesize bao_caseUrl;
@synthesize baoUrl;
@synthesize uploadProfileurl;
@synthesize receiveData;


//外网
//NSString *baseUrl = @"http://115.28.18.130/SEMBAWEBDEVELOP/api/";


+(id)sharedDao{
    
    if(sharedDaoer == nil){
        sharedDaoer = [[Dao alloc] init];
//        sharedDaoer.imageBaseUrl = @"http://192.168.1.200/huobao_us/";
        sharedDaoer.imageBaseUrl = @"http://115.28.18.130/huobao_us/";
        [sharedDaoer isNetWorkAvalible];
        [sharedDaoer initNetworkStateObserver];
        
        //内网
//        sharedDaoer.baseUrl = @"http://192.168.1.200/huobao_us/index.php/api";
        sharedDaoer.baseUrl = @"http://115.28.18.130/huobao_us/index.php/api";
        //获取验证码
        sharedDaoer.verifyCode = @"/user/verifyCode";
        //验证码验证
        sharedDaoer.validate = @"/user/validate";
        //填写信息注册
        sharedDaoer.registerStr = @"/user/register";
        //登录
        sharedDaoer.login = @"/user/login";
        //个人信息
        sharedDaoer.getInfo = @"/user/getInfo";
        //好友列表 A的好友列表
        sharedDaoer.getfriend = @"/friend/getfriend";
        //删除好友
        sharedDaoer.deletefriend = @"/friend/request_del";
        //请求加好友 A请求B为好友
        sharedDaoer.addfriend = @"/friend/request_add";
        //请求好友列表 B的被请求列表
        sharedDaoer.addfriendlist = @"/friend/request_list";
        //同意加好友 B同意A的请求加好友
        sharedDaoer.acceptfriend = @"/friend/accept";
        //获取好友详情
        sharedDaoer.getInfoOther = @"/user/getInfoOther";
        //活列表的获取
        sharedDaoer.huoUrl = @"/huobao/huo";
        sharedDaoer.baoUrl = @"/huobao/bao";
        //参加活动的url
//        sharedDaoer.joinUrl = @"http://192.168.1.200/huobao_us/index.php/huobao/auction_involve/join";
        sharedDaoer.joinUrl = @"http://115.28.18.130/huobao_us/index.php/huobao/auction_involve/join";
        sharedDaoer.historyCreditUrl = @"/user/extcredits_history";
        sharedDaoer.huo_caseUrl = @"huobao/huo_case";
        sharedDaoer.bao_caseUrl = @"huobao/bao_case";
        sharedDaoer.uploadProfileurl = @"/user/profile_upload";
    }
    return sharedDaoer;
}

-(void)initNetworkStateObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            self.reachbility = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachbility = NO;
            //blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //有网
        //notificationLabel.text = @"Notification Says Reachable";
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
        //断网
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

-(void)isNetWorkAvalible
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if([reach isReachable])
    {
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
    }
}

//***********************************登录*******************************************//
-(void)loginRequestWithdict:(NSDictionary *)dict
{
    if (!self.reachbility) {
        [self.daoDelegate requestSucceedWithStateID:-1 withErrorStirng:@"无法连接服务器"];//-1代表当前网络不可用
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,login];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *reqForm = [ASIFormDataRequest requestWithURL:url];
    [reqForm setDidFailSelector:@selector(loginRequestFaild:)];
    [reqForm setDidFinishSelector:@selector(loginRequestSucceeded:)];
    [self requestwithDataRequest:reqForm dict:(NSDictionary *)dict];
}


//登录请求失败
-(void)loginRequestFaild:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    NSString *errorString = [error localizedDescription];
    if (errorString == nil || [errorString isEqualToString:@""]) {
        errorString = @"连接服务器失败";
    }
    [daoDelegate requestSucceedWithStateID:0 withErrorStirng:errorString];
}

//登录请求成功
-(void)loginRequestSucceeded:(ASIHTTPRequest *)request
{
    NSData *receiveData = [request responseData];
    NSString *receiveString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    
    HeSysbsModel *sysModel = [HeSysbsModel getSysbsModel];
    sysModel.user = [[HeUser alloc] init];
    sysModel.user.userImage = [[AsynImageView alloc] init];
    sysModel.user.userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];

    NSDictionary *dic = [receiveString objectFromJSONString];
    NSString *uidStr = [dic objectForKey:@"id"];
    if (uidStr == nil || [uidStr isMemberOfClass:[NSNull class]]) {
        uidStr = @"";
    }
    sysModel.user.uid = [uidStr intValue];
    
    //获取状态ID
    int stateid = [[dic objectForKey:@"state"] intValue];
    NSString *errorString = nil;
    sysModel.user.stateID = stateid;
    if (stateid != 1) {
        errorString = [dic objectForKey:@"msg"];
        if ([errorString isMemberOfClass:[NSNull class]] || [errorString isEqualToString:@""]) {
            errorString = @"无法连接服务器";
        }
        [daoDelegate requestSucceedWithStateID:stateid withErrorStirng:errorString];
        return;
    }
   
    NSString *nationality = [dic objectForKey:@"nationality"];
    if (nationality == nil || [nationality isMemberOfClass:[NSNull class]]) {
        nationality = @"中国";
    }
    NSString *residecity = [dic objectForKey:@"residecity"];
    if (residecity == nil || [residecity isMemberOfClass:[NSNull class]]) {
        residecity = @"";
    }
    NSString *residedist = [dic objectForKey:@"residedist"];
    if (residedist == nil || [residedist isMemberOfClass:[NSNull class]]) {
        residedist = @"";
    }
    NSString *resideprovince = [dic objectForKey:@"resideprovince"];
    if (resideprovince == nil || [resideprovince isMemberOfClass:[NSNull class]]) {
        resideprovince = @"";
    }
    sysModel.user.address = [NSString stringWithFormat:@"%@ %@ %@ %@",nationality,resideprovince,residecity,residedist];
    
    NSString *sessionKey = [dic objectForKey:@"sessionKey"];
    if (sessionKey == nil || [sessionKey isMemberOfClass:[NSNull class]]) {
        sessionKey = @"";
    }
    sysModel.user.sessionKey = sessionKey;
    
    NSString *profile = [dic objectForKey:@"profile"];
    if (profile == nil || [profile isMemberOfClass:[NSNull class]]) {
        profile = @"";
    }
    
    NSString *sexStr = [dic objectForKey:@"sex"];
    if (sexStr == nil || [sexStr isMemberOfClass:[NSNull class]]) {
        sexStr = @"";
    }
    int sex = [sexStr intValue];
    if (sex != 1) {
        sex = 2;
    }
    sysModel.user.sex = sex;
   
    NSString *nichen = [dic objectForKey:@"nickname"];
    if (nichen == nil || [nichen isMemberOfClass:[NSNull class]]) {
        nichen = @"";
    }
    sysModel.user.nichen = nichen;
    
    NSString *sign = [dic objectForKey:@"signature"];
    if (sign == nil || [sign isMemberOfClass:[NSNull class]]) {
        sign = @"";
    }
    sysModel.user.sign = sign;
    
    NSString *address = [dic objectForKey:@"address"];
    if (address == nil || [address isMemberOfClass:[NSNull class]]) {
        address = @"";
    }
    sysModel.user.address = address;
    
    NSString *phone = [dic objectForKey:@"phone"];
    if (phone == nil || [phone isMemberOfClass:[NSNull class]]) {
        phone = @"";
    }
    sysModel.user.phone = phone;
    
    NSString *email = [dic objectForKey:@"email"];
    if (email == nil || [email isMemberOfClass:[NSNull class]]) {
        email = @"";
    }
    sysModel.user.email = email;
    
    NSString *birthday = [dic objectForKey:@"birthday"];
    if (birthday == nil || [birthday isMemberOfClass:[NSNull class]]) {
        birthday = @"";
        
    }
    sysModel.user.birthday = birthday;
    
    
    
    NSDictionary *countDic = [dic objectForKey:@"count"];
    if (countDic == nil || [countDic isMemberOfClass:[NSNull class]]) {
        countDic = nil;
    }
    sysModel.user.countDic = countDic;
    
    NSString *jifen = [countDic objectForKey:@"extcredits2"];
    if (jifen == nil || [jifen isMemberOfClass:[NSNull class]]) {
        jifen = @"0";
    }
    sysModel.user.jifen = jifen;
    
    NSString *summary = [dic objectForKey:@"summary"];
    if (summary == nil || [summary isMemberOfClass:[NSNull class]]) {
        summary = @"";
    }
    sysModel.user.summary = summary;
    
    NSString *vipStr = [dic objectForKey:@"vip"];
    if (vipStr == nil || [vipStr isMemberOfClass:[NSNull class]]) {
        vipStr = @"";
    }
    int vip = [vipStr intValue];
    sysModel.user.statue = vip;
    
    NSString *uuid = [dic objectForKey:@"uuid"];
    if (uuid == nil || [uuid isMemberOfClass:[NSNull class]]) {
        uuid = @"";
    }
    sysModel.user.uuid = uuid;
    NSString *profileurlString = [NSString stringWithFormat:@"%@//data/profile/%@.png",imageBaseUrl,uuid];
    sysModel.user.userImage.imageURL = profileurlString;
    
    NSString *passport = [dic objectForKey:@"passport"];
    if (passport == nil || [passport isMemberOfClass:[NSNull class]]) {
        passport = @"";
    }
    sysModel.user.passport = passport;
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentString = [pathArray objectAtIndex:[pathArray count] - 1];
    NSString *uuidPath = [documentString stringByAppendingPathComponent:@"uuid.plist"];
    NSDictionary *uuidDic = [[NSDictionary alloc] initWithObjectsAndKeys:uuid,@"uuid", nil];
    BOOL succeed = [uuidDic writeToFile:uuidPath atomically:YES];
    if (succeed) {
        NSLog(@"succeed");
    }
    
    NSString *userPath = [documentString stringByAppendingPathComponent:@"userData.plist"];
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:receiveString,@"user", nil];
    succeed = [myDict writeToFile:userPath atomically:YES];
    if (succeed) {
        NSLog(@"succeed");
    }
    
    [daoDelegate requestSucceedWithStateID:stateid withErrorStirng:errorString];
}
//***********************************登录*******************************************//


//***********************************注册*******************************************//
//获取验证码
-(NSDictionary *)registWithPhone:(NSDictionary *)dict
{
    //同步post
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",baseUrl,verifyCode];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
}
//验证验证码
-(NSDictionary *)validateWithCode:(NSDictionary *)dict
{
    //同步post
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",baseUrl,validate];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
}
//填写注册信息
-(NSDictionary *)registerWithDic:(NSDictionary *)dict
{
    //同步post
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",baseUrl,registerStr];
    NSDictionary *myDic = [self request:urlstring dict:dict];
    return myDic;
}
//***********************************注册*******************************************//








//***********************************同步请求好友列表*******************************************//


//同步post的公共方法
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict{

    NSDictionary *response = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if(!self.reachbility)return nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f ];
    NSString *jsonString = [dict JSONString];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString* receivedStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
        return nil;
    }
    response = [receivedStr objectFromJSONString];
    return response;
}

//异步POST的公共方法
-(void)requestwithDataRequest:(ASIFormDataRequest *)reqForm dict:(NSDictionary *)dict
{
    NSString *jsonString = [dict JSONString];
    
    NSData *sendData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *sendMutableData = [[NSMutableData alloc] initWithData:sendData];
    [reqForm setPostBody:sendMutableData];
    [reqForm setRequestMethod:@"POST"];
    [reqForm setTimeOutSeconds:10.0f];
    [reqForm setDelegate:self];
    [reqForm startAsynchronous];
}

//图片异步POST的公共方法
-(void)requestwithPicDataRequest:(ASIFormDataRequest *)reqForm dict:(NSDictionary *)dict
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,self.uploadProfileurl];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[dict objectForKey:@"profile"];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 0.8);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [dict allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"profile"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"profile\"; filename=\"boris.jpeg\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
//    //设置接受response的data
//    if (conn) {
//        mResponseData = [[NSMutableData data] retain];
//    }

    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (receiveData != nil) {
        
        receiveData = nil;
    }
    
    receiveData = [[NSMutableData alloc] initWithCapacity:1];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",receiveData);
    NSString *str = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}
@end
