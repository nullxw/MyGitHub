//
//  HeHuoBaoDBManager.h
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"HuoBaoDataBase.sqlite3"

@interface HeHuoBaoDBManager : NSObject

/****/
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)createDataBase;

@end
