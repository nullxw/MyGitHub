//
//  HeGiveTicketV.h
//  huobao
//
//  Created by Tony He on 14-5-19.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAddressBook.h"
#import "HeGiveTicketCell.h"
#import "Dao.h"

@interface HeGiveTicketV : UIViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithArray:(NSArray *)array;

@end
