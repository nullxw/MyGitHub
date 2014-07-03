//
//  TKContactsMultiPickerController.h
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "TKAddressBook.h"
#import "TKContactsMultiPickerCell.h"
#import "HeGiveTicketV.h"
#import "MBProgressHUD.h"
#import "Dao+asyncFriendCategory.h"

@class TKAddressBook, TKContactsMultiPickerController;
@protocol TKContactsMultiPickerControllerDelegate <NSObject>
@required
- (void)contactsMultiPickerController:(TKContactsMultiPickerController*)picker didFinishPickingDataWithInfo:(NSArray*)data;
- (void)contactsMultiPickerControllerDidCancel:(TKContactsMultiPickerController*)picker;

@end



@interface TKContactsMultiPickerController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,MBProgressHUDDelegate,DaoProtocol>
{
	id _delegate;
    
@private
    NSUInteger _selectedCount;
    NSMutableArray *_listContent;
	NSMutableArray *_filteredListContent;
}

@property (nonatomic, retain) id<TKContactsMultiPickerControllerDelegate> delegate;


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) int loadSucceedFlag;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property(strong,nonatomic)NSMutableArray *downloadedArray;
@property(strong,nonatomic)NSMutableArray *pictureArray;

@end
