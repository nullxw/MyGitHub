//
//  HeSysbsModel.h
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeUser.h"

@interface HeSysbsModel : NSObject

@property(strong,nonatomic)NSMutableArray *listContent;//通讯录
@property(strong,nonatomic)HeUser *user;//用户


+(HeSysbsModel*)getSysbsModel;

@end
