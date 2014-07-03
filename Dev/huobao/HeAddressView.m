//
//  HeAddressView.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeAddressView.h"

BMKAnnotationView *annotationView;

@interface HeAddressView ()
@property(strong,nonatomic)HeBMap *shareMap;
@property(strong,nonatomic)NSDictionary *myDic;
@property(strong,nonatomic)BMKPointAnnotation *mapAnnotation;
@property(strong,nonatomic)NSMutableArray *pointAnnotationArray;

@end

@implementation HeAddressView
@synthesize shareMap;
@synthesize myDic;
@synthesize mapAnnotation;
@synthesize pointAnnotationArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"活动地点";
        [label sizeToFit];
    }
    return self;
}

-(id)initAddressViewWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        myDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControl];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    shareMap = [HeBMap getBMap];
    [shareMap.mapView viewWillAppear];
    shareMap.mapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    shareMap.mapView.delegate = self;
    shareMap.locService.delegate = self;
    [self.view addSubview:shareMap.mapView];
    [shareMap.locService startUserLocationService];
    shareMap.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    shareMap.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    shareMap.mapView.showsUserLocation = YES;//显示定位图层
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addAnnotationToMap];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [shareMap.mapView viewWillDisappear];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSArray* array = [NSArray arrayWithArray:shareMap.mapView.annotations];
    if (array != nil) {
        [shareMap.mapView removeAnnotations:array];
    }
	if (array != nil) {
        array = [NSArray arrayWithArray:shareMap.mapView.overlays];
        [shareMap.mapView removeOverlays:array];
    }
    shareMap.mapView.delegate = nil;
    shareMap.locService.delegate = nil;
    
}

-(void)initControl
{
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_backItem.png"]];
    backImage.frame = CGRectMake(self.navigationController.navigationBar.frame.size.height - 30, (self.navigationController.navigationBar.frame.size.height - 30)/2, 25, 25);
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTolastView:)];
    backTap.numberOfTapsRequired = 1;
    backTap.numberOfTouchesRequired = 1;
    [backImage addGestureRecognizer:backTap];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backImage];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"btn_backItem.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftBarItem setBackgroundImage:[UIImage imageNamed:@"btn_backItem_highlighted.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [leftBarItem setTarget:self];
    [leftBarItem setAction:@selector(backTolastView:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
}

-(void)initView
{
    pointAnnotationArray = [[NSMutableArray alloc] initWithCapacity:0];
}

-(void)backTolastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAnnotationToMap
{
    CLLocationCoordinate2D coordinate;
    NSString *latitude = [myDic objectForKey:@"latitude"];
    NSString *longitude = [myDic objectForKey:@"longitude"];
    if ([latitude isMemberOfClass:[NSNull class]] || latitude == nil) {
       
        latitude = @"0";
        longitude = @"0";
    }
    coordinate.latitude = [latitude doubleValue];
    coordinate.longitude = [longitude doubleValue];
    mapAnnotation = [[BMKPointAnnotation alloc] init];
    NSString *titleString = [myDic objectForKey:@"name"];
    if ([titleString isMemberOfClass:[NSNull class]] || titleString == nil) {
        titleString = @"匿名";
    }
    mapAnnotation.title = titleString;
    mapAnnotation.coordinate = coordinate;
    [pointAnnotationArray addObject:mapAnnotation];
    [shareMap.mapView addAnnotation:mapAnnotation];
    
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    [shareMap.mapView setRegion:region animated:YES];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [shareMap.mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [shareMap.mapView updateLocationData:userLocation];
//    [shareMap.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

/***标注的一些代理方法***/
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
        ((BMKPinAnnotationView*)annotationView).draggable = NO;
    }
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    
    return annotationView;
    
}


-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"select annotationview");
}

-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"annotationview for bubble");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
