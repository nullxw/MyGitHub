//
//  HeGuestView.h
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeGuestView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL update;
    NSIndexPath *updatePath;
}

@end
