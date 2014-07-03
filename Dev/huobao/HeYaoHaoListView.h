//
//  HeYaoHaoListView.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeYaoHaoCell.h"

@interface HeYaoHaoListView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)IBOutlet UITableView *yaoHaoTble;
@end
