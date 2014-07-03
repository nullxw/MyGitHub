//
//  HeBMap.h
//  huobao
//
//  Created by HeDongMing on 14-6-21.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface HeBMap : NSObject

@property(strong,nonatomic) BMKMapView *mapView;
@property(strong,nonatomic) BMKPoiSearch *search;
@property(strong,nonatomic) BMKLocationService *locService;

+(id)getBMap;

@end
