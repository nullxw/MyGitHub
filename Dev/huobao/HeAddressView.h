//
//  HeAddressView.h
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeBMap.h"

@interface HeAddressView : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKLocationServiceDelegate>


-(id)initAddressViewWithDic:(NSDictionary *)dic;

@end
