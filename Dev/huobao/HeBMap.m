//
//  HeBMap.m
//  huobao
//
//  Created by HeDongMing on 14-6-21.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeBMap.h"

static HeBMap *shareMap = nil;

@implementation HeBMap
@synthesize mapView;
@synthesize search;
@synthesize locService;

+(id)getBMap
{
    if (shareMap == nil) {
        shareMap = [[HeBMap alloc] init];
        shareMap.mapView = [[BMKMapView alloc] init];
        shareMap.search = [[BMKPoiSearch alloc] init];
        shareMap.locService = [[BMKLocationService alloc] init];
    }
    return shareMap;
}


+(double)getDistance:(double*)array
{
    double EARTH_RADIUS = 6378.137;
    
    
    double lat1 = array[0];
    double lng1 = array[1];
    double lat2 = array[2];
    double lng2 = array[3];
    
    double radLat1 = [HeBMap rad:lat1];
    double radLat2 = [HeBMap rad:lat2];
    double a = radLat1 - radLat2;
    double b = [HeBMap rad:lng1] - [HeBMap rad:lng2];
    
    double s = asin(sqrt(pow(sin(a / 2), 2)
                         + cos(radLat1) * cos(radLat2)
                         * pow(sin(b / 2), 2)));
    double returndoble = s * EARTH_RADIUS;
    return returndoble;
    
}
+(double)rad:(double) d{
    return d * 3.1415926 / 180.0;
}

+(NSString*)getDisDistance:(double)distance{
    if (distance < 1) {
        if (distance * 1000 < 100) {
            distance = 100;
        }
        else
        {
            distance = distance * 1000;
        }
        double temp = round(distance);
        return [NSString stringWithFormat:@"%d米",(int)temp];
    }
    else
    {
        double temp = round(distance);
        return [NSString stringWithFormat:@"%d公里",(int)temp];
    }
}

@end
