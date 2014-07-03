//
//  HeModifyInfoView.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeSysbsModel.h"
#import "MBProgressHUD.h"

@interface HeModifyInfoView : UIViewController<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITextField *modifyTF;

@property(assign,nonatomic)BOOL popToRoot;
-(id)initWithDict:(NSDictionary *)dict;

@end
