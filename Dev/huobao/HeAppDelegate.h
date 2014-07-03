//
//  HeAppDelegate.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"
#import "TestFlight.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "BMapKit.h"
#import "EaseMob.h"
#import "ChatListViewController.h"
#import "ApplyViewController.h"
#import "ContactsViewController.h"


@interface HeAppDelegate : UIResponder <UIApplicationDelegate,NGTabBarControllerDelegate,BMKGeneralDelegate,IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
