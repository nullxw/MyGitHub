//
//  NGTestTabBarController.h
//  NGVerticalTabBarControllerDemo
//
//  Created by Tretter Matthias on 24.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGTabBarController.h"
#import "EaseMob.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"

@interface NGTestTabBarController : NGTabBarController<UINavigationControllerDelegate>

@property(strong,nonatomic)ChatListViewController *chatListVC;
@property(strong,nonatomic)ContactsViewController *contactsVC;
- (void)jumpToChatList;

@end
