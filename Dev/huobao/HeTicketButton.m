//
//  HeTicketButton.m
//  huobao
//
//  Created by Tony He on 14-5-20.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "HeTicketButton.h"

@implementation HeTicketButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Type:(int)type count:(int)remainCount
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"ticketNoSelect.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ticketSelect.png"] forState:UIControlStateSelected];
        NSString *buttonStirng = @"学生票";
        switch (type) {
            case 0:
            {
                buttonStirng = @"学生票";
                
                break;
            }
            case 1:
            {
                buttonStirng = @"家长联票";
                break;
            }
            case 2:
            {
                buttonStirng = @"免费资格票";
                break;
            }
            default:
                break;
        }
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        [self addSubview:label];
        label.frame = CGRectMake(20, 5, 200, 20.0);
        label.text = buttonStirng;
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        [self addSubview:label1];
        label1.frame = CGRectMake(20, 25, 200, 15.0);
        label1.text = @"免费参会资格，名额有限";
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor grayColor];
        numberLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        [self addSubview:numberLabel];
        numberLabel.frame = CGRectMake(200, 5, 50,20.0);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = [NSString stringWithFormat:@"%d",remainCount];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        label2.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        [self addSubview:label2];
        label2.frame = CGRectMake(200, 30, 50, 15.0);
        label2.text = @"剩余";
        label2.textAlignment = NSTextAlignmentCenter;
        
        
    }
    
    return self;
}
-(void)initView
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
