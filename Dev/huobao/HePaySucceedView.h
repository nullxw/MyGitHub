//
//  HePaySucceedView.h
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HeMyBaoBoxView.h"
#import "HeHuoViewController.h"
#import "HeMyHuoBoxView.h"
#import <ShareSDK/ShareSDK.h>

@interface HePaySucceedView : UIViewController<UITextViewDelegate>

@property(assign,nonatomic)int type;
@property(strong,nonatomic)NSDictionary *mydic;
-(id)initWithDic:(NSDictionary *)dic;

@end
