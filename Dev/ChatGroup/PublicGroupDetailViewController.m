/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "PublicGroupDetailViewController.h"

@interface PublicGroupDetailViewController ()

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) EMGroup *group;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation PublicGroupDetailViewController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self fetchGroupInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
        [_headerView addSubview:imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, _headerView.frame.size.width - 80 - 20, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = (_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId;
        [_headerView addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, _headerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, _footerView.frame.size.width - 80, 40)];
        [joinButton setTitle:@"加入群组" forState:UIControlStateNormal];
        [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [joinButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        [_footerView addSubview:joinButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"群主";
        cell.detailTextLabel.text = [_group.owners objectAtIndex:0];
    }
    else{
        cell.textLabel.text = @"群组简介";
        cell.detailTextLabel.text = _group.groupDescription;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }
    else{
        CGSize size = [_group.groupDescription sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        
        return size.height > 30 ? (20 + size.height) : 50;
    }
}

#pragma mark - action

- (void)fetchGroupInfo
{
    [self showHudInView:self.view hint:@"加载数据..."];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_groupId completion:^(EMGroup *group, EMError *error) {
        weakSelf.group = group;
        [weakSelf reloadSubviewsInfo];
        [weakSelf hideHud];
    } onQueue:nil];
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nameLabel.text = (_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId;
        [weakSelf.tableView reloadData];
    });
}

- (void)joinAction
{
    [self showHudInView:self.view hint:@"加入群组..."];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:_groupId completion:^(EMGroup *group, EMError *error) {
        if(!error)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:@"加入群组失败，请重新操作"];
        }
    } onQueue:nil];
}

@end
