//
//  KKBookView.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 7/11/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookView.h"

@implementation KKBookView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = NO; // if you like rounded corners
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        
    }
    return self;
}
- (void)awakeFromNib{
    self.layer.masksToBounds = NO; // if you like rounded corners
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    CGSize size = self.bounds.size;
    CGRect ovalRect = CGRectMake(0,CGRectGetWidth(self.frame) + 4, size.width,0.25);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:ovalRect];
    self.layer.shadowPath = path.CGPath;
    
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize size = self.bounds.size;
    CGRect ovalRect = CGRectMake(0,CGRectGetWidth(self.frame) + 4, size.width,0.25);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:ovalRect];
    self.layer.shadowPath = path.CGPath;
}


@end
