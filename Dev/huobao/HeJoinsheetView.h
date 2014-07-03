//
//  HeJoinsheetView.h
//  huobao
//
//  Created by Tony He on 14-5-22.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
#import "UIButton+Bootstrap.h"
#import "Dao+baoCategory.h"
#import "HeSysbsModel.h"
#import "MBProgressHUD.h"
#import "HePaySucceedView.h"

@interface HeJoinsheetView : UIViewController<UITextViewDelegate,UITextFieldDelegate,DaoProtocol,MBProgressHUDDelegate>

@property(assign,nonatomic)int loadSucceedFlag;
@property(assign,nonatomic)int type;
/**
 *    @brief 利用活动进行初始化
 *    @param dic 活动的字典
 *    @return 返回self
 */
-(id)initWithActivityDic:(NSDictionary *)dic;

@end
