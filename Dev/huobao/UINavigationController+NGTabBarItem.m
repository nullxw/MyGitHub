//
//  UINavigationController+NGTabBarItem.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "UINavigationController+NGTabBarItem.h"
#import "NGTabBarItem.h"
#import <objc/runtime.h>

static char itemKey;

@implementation UINavigationController (NGTabBarItem)

- (void)ng_setTabBarItem:(NGTabBarItem *)ng_tabBarItem {
    objc_setAssociatedObject(self, &itemKey, ng_tabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NGTabBarItem *)ng_tabBarItem {
    return objc_getAssociatedObject(self, &itemKey);
}

@end
