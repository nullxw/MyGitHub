//
//  HeHuoBaoDBManager.m
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeHuoBaoDBManager.h"

static FMDatabase *shareDataBase = nil;

@implementation HeHuoBaoDBManager

+ (FMDatabase *)createDataBase
{
    if (shareDataBase == nil) {
        shareDataBase = [[FMDatabase alloc] initWithPath:dataBasePath];
    }
    return shareDataBase;
}

@end
