//
//  KKBookFontHeaderPhone.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 7/11/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookFontHeaderPhone.h"

@implementation KKBookFontHeaderPhone

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.font = [UIFont fontBoldWithSize:20];
    self.textColor = [UIColor KKBookOrangeColor];
}

@end
