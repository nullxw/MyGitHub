//
//  HeDetailInfoView.h
//  huobao
//
//  Created by Tony He on 14-5-15.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dao.h"
#import "HeSysbsModel.h"
#import "Dao+baoCategory.h"
#import "MBProgressHUD.h"

@interface HeDetailInfoView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DaoProtocol,MBProgressHUDDelegate>
{
    NSMutableData *receiveData;
    NSURLConnection *connection;
    
}
@property(assign,nonatomic)BOOL popToRoot;
@property(assign,nonatomic)int loadSucceedFlag;
@end
