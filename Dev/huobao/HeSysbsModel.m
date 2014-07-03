//
//  HeSysbsModel.m
//  huobao
//
//  Created by Tony He on 14-5-18.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeSysbsModel.h"
#import "AsynImageView.h"

static HeSysbsModel* sharedModel = nil;

@implementation HeSysbsModel
@synthesize listContent;
@synthesize user;

+(HeSysbsModel*)getSysbsModel{
    if(sharedModel == nil){
        NSLog(@"create!!!");
        sharedModel = [[HeSysbsModel alloc] init];
        sharedModel.listContent = [[NSMutableArray alloc] initWithCapacity:0];
        sharedModel.user = [[HeUser alloc] init];
        sharedModel.user.userImage = [[AsynImageView alloc] init];
        sharedModel.user.userImage.placeholderImage = [UIImage imageNamed:@"头像默认图.png"];
        
    }
    return sharedModel;
}


@end
