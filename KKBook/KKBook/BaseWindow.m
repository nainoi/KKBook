//
//  SCBEasyWindow.m
//  SCBEASY
//
//  Created by Ittipong on 5/24/14.
//  Copyright (c) 2014 Promptnow MacMini's PE. All rights reserved.
//

#import "BaseWindow.h"
#import "AppDelegate.h"

@implementation BaseWindow{
    NSTimer *idleTimer;
    UIView *currentFirstResponder_;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // [self commonInit];
         [self resetIdleTimer];
    }
    return self;
}

- (void)sendEvent:(UIEvent *)event {
  //   [self adjustFirstResponderForEvent:event];
    [super sendEvent:event];
    //[super sendEvent:event];
    [self interceptEvent:event];

    /*NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {

        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded){
            [self resetIdleTimer];
            
        }
        if (phase == UITouchPhaseEnded) {
        //    [SCBEasyBase_ViewController closeLeftMenu];
        }
    }*/
}

- (void)resetIdleTimer {
    if (idleTimer) {
        [idleTimer invalidate];
        
    }
    //300
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

- (void)idleTimerExceeded {

    //[[NSNotificationCenter defaultCenter]postNotificationName:@"Session_Idle_Time" object:nil];
    [self performSelector:@selector(showPasscodeView) withObject:nil afterDelay:0.75];
    
}

-(void)showPasscodeView{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.wantToLogin = YES;
//    [appDelegate showPasscode];
}

- (void)commonInit {
    [self startObservingFirstResponder];
}
- (void)dealloc {
    [self stopObservingFirstResponder];
}
- (void)adjustFirstResponderForEvent:(UIEvent *)event {
    if (currentFirstResponder_
        && ![self eventContainsTouchInFirstResponder:event]
        && [self eventContainsNewTouchInNonresponder:event]) {
        [currentFirstResponder_ resignFirstResponder];
    }
}
- (BOOL)eventContainsTouchInFirstResponder:(UIEvent *)event {
    for (UITouch *touch in [event touchesForWindow:self]) {
        if (touch.view == currentFirstResponder_)
            return YES;
    }
    return NO;
}
- (BOOL)eventContainsNewTouchInNonresponder:(UIEvent *)event {
    for (UITouch *touch in [event touchesForWindow:self]) {
        if (touch.phase == UITouchPhaseBegan && ![touch.view canBecomeFirstResponder])
            return YES;
    }
    return NO;
}
-(void)startObservingFirstResponder {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(observeBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)stopObservingFirstResponder {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)observeBeginEditing:(NSNotification *)note {
    currentFirstResponder_ = note.object;
}

- (void)observeEndEditing:(NSNotification *)note {
    if (currentFirstResponder_ == note.object) {
        currentFirstResponder_ = nil;
    }
}

#pragma mark - Events management

- (void)interceptEvent:(UIEvent *)event {
    
    if (event.type == UIEventTypeTouches)
    {
        NSSet *touches = [event allTouches];
        if (touches.count == 1)
        {
            UITouch *touch = touches.anyObject;
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:touch, @"touch", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_touch_intercepted" object:nil userInfo:userInfo];
        }
    }
}


@end
