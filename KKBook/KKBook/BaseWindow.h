//
//  SCBEasyWindow.h
//  SCBEASY
//
//  Created by Ittipong on 5/24/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWindow : UIWindow

- (void)resetIdleTimer;
- (void)interceptEvent:(UIEvent *)event;

@end
