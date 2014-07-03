//
//  UINavigationController+NGTabBarItem.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGTabBarItem;

@interface UINavigationController (NGTabBarItem)

@property (nonatomic, strong, setter = ng_setTabBarItem:) NGTabBarItem *ng_tabBarItem;

@end
