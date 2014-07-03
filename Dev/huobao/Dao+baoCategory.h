//
//  Dao+baoCategory.h
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao.h"
#import "JSONKit/JSONKit.h"

@interface Dao (baoCategory)

-(void)asyncHuoListWith:(NSDictionary *)dict;
-(void)asyncBaoListWith:(NSDictionary *)dict;

-(void)asyncJoinActivityWith:(NSDictionary *)dict;

/*
 * @brief 获取积分历史
 */
-(void)asyncgetCreditHistoryWith:(NSDictionary *)dict;
//获取活箱
-(void)asyncgetHuo_caseWith:(NSDictionary *)dict;
//上传头像
-(void)asyncUploadProfile:(NSDictionary *)dict;

@end
