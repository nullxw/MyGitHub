//
//  HeFriendViewController.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "TKAddressBook.h"
#import "HeGiveTicketV.h"
#import "ZBarSDK.h"
#import "UIButton+Bootstrap.h"
#import "AsynImageView.h"
#import "UIButton+Bootstrap.h"
#import "HeMylongpress.h"
#import "HeMylongpress+category.h"
#import "HeFriendViewCell.h"
#import "Dao.h"
#import "HeSysbsModel.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "JSONKit/JSONKit.h"
#import "TKAddressBook.h"
#import "HeNewFriendListView.h"
#import "Dao+asyncFriendCategory.h"

@class TKAddressBook, TKContactsMultiPickerController;




@interface HeFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, ZBarReaderDelegate,UIAlertViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,updateFriendListProtocol,DaoProtocol>
{
	id _delegate;
    BOOL _reloading;
    NSInteger offset;
    
@private
    NSUInteger _selectedCount;
    
	NSMutableArray *_filteredListContent;
}




@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UIImageView *line;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property(strong,nonatomic)NSMutableArray *listContent;
@property(strong,nonatomic)NSMutableArray *downloadedArray;
@property(strong,nonatomic)NSMutableArray *pictureArray;
@property(strong,nonatomic)NSIndexPath *currentIndexpath;
@property(strong,nonatomic)EGORefreshTableHeaderView *headerRefreshView;
@property(assign,nonatomic)int loadSucceedFlag;

@end
