//
//  HeqViewController.m
//  huobao
//
//  Created by Tony He on 14-5-23.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeqViewController.h"
#import "CPTextViewPlaceholder.h"

@interface HeqViewController ()
@property(strong,nonatomic)IBOutlet UIButton *bt;
@property(strong,nonatomic)IBOutlet CPTextViewPlaceholder *shareTF;

@end

@implementation HeqViewController
@synthesize shareTF;
@synthesize bt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [bt infoStyle];
    CGRect frame = shareTF.frame;
    shareTF = [[CPTextViewPlaceholder alloc] init];
    shareTF.frame = frame;
    shareTF.placeholder = @"分享你的心得";
    shareTF.layer.cornerRadius = 5.0f;
    shareTF.layer.borderWidth = 1.0f;
    shareTF.layer.borderColor = [[UIColor grayColor] CGColor];
    shareTF.layer.masksToBounds = YES;
    shareTF.delegate = self;
    shareTF.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [self.view addSubview:shareTF];
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finish:)];
    finishButton.title = @"完成";
    NSArray *bArray = [NSArray arrayWithObjects:finishButton, nil];
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];//创建工具条对象
    tb.items = bArray;
    shareTF.inputAccessoryView = tb;//将工具条添加到UITextView的响应键盘
    
    shareTF.returnKeyType = UIReturnKeyDefault;
    shareTF.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

-(void)finish:(id)sender
{
    if ([shareTF isFirstResponder]) {
        [shareTF resignFirstResponder];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
