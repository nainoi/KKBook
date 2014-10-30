//
//  UINavigationBar+SCBNavigationBar.m
//  SCBEASY
//
//  Created by Ittipong on 7/17/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import "UINavigationBar+SCBNavigationBar.h"
@implementation UINavigationBar (SCBNavigationBar)
@dynamic barColor;
- (void)setBarColor:(UIColor *)barColor{
    
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        self.barTintColor = barColor;
    }else{
        self.backgroundColor = barColor;
    }
    
}
@end
