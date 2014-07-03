//
//  HeActivityDetailView.h
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActivity.h"
#import "HeJoinsheetView.h"
#import "TFHpple.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@interface HeActivityDetailView : UIViewController<UITableViewDataSource,UITableViewDelegate,LXActivityDelegate>
{
    CGRect original_tableframe;
}

@property(assign,nonatomic)int type;
-(id)initWithActivityDict:(NSDictionary *)dic;

@end
