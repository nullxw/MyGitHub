//
//  HeBaoPiaoDetailView.h
//  huobao
//
//  Created by Tony He on 14-5-16.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"
#import "UIButton+Bootstrap.h"
#import "TKContactsMultiPickerController.h"

@interface HeBaoPiaoDetailView : UIViewController<UIScrollViewDelegate>
{
    int typeID;
}

@property(strong,nonatomic)IBOutlet UIImageView *bgImage;
@property(strong,nonatomic)IBOutlet AsynImageView *asyImage;
@property(strong,nonatomic)IBOutlet UIImageView *piaoBgImage;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UILabel *timeLabel;
@property(strong,nonatomic)IBOutlet UILabel *addressLabel;
@property(strong,nonatomic)IBOutlet UILabel *numberLabel;
@property(strong,nonatomic)IBOutlet UIButton *activityButton;
@property(strong,nonatomic)IBOutlet UILabel *d_addressLabel;
@property(strong,nonatomic)IBOutlet UILabel *d_timeLabel;
@property(strong,nonatomic)IBOutlet UILabel *renshuLabel;
@property(strong,nonatomic)IBOutlet UILabel *priceLabel;
@property(strong,nonatomic)IBOutlet UILabel *menPiaoLabel;
@property(strong,nonatomic)IBOutlet UIButton *giveButton;
@property(strong,nonatomic)IBOutlet UIButton *escButton;
@property(strong,nonatomic)IBOutlet UILabel *bgLabel;
@property(strong,nonatomic)IBOutlet UIScrollView *myscrollview;
@property(strong,nonatomic)NSString *imageurl;

-(IBAction)giveButtonClick:(id)sender;//转赠
-(IBAction)escButtonClick:(id)sender;//退票
-(IBAction)activityButtonClick:(id)sender;//查看活动详情

-(id)initWitgTypeID:(int)type;

@end
