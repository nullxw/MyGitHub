//
//  HeSubscribeViewController.h
//  huobao
//
//  Created by Tony He on 14-5-23.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeSubscribeCell.h"
#import "HeActivityDetailView.h"

@interface HeSubscribeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL update;
    NSIndexPath *updatePath;
}

@property(strong,nonatomic)NSDictionary *scribeDic;

@end
