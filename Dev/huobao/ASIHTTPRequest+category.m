//
//  ASIHTTPRequest+category.m
//  huobao
//
//  Created by Tony He on 14-5-30.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import <objc/runtime.h>

static void *myKey = (void *)@"myKey";

@implementation ASIHTTPRequest (associate)

- (NSDictionary *)myDict{
    return objc_getAssociatedObject(self, myKey);
}

- (void) setMyDict:(NSDictionary *)myDict{
    objc_setAssociatedObject(self, myKey, myDict, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
