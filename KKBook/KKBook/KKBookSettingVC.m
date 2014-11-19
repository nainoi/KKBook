//
//  KKBookSettingVC.m
//  KKBooK
//
//  Created by PromptNow on 11/13/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookSettingVC.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface KKBookSettingVC ()<MFMailComposeViewControllerDelegate>

@end

@implementation KKBookSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didAboutUs:(id)sender {
}

- (IBAction)didFeedBack:(id)sender {
    // Email Subject
    NSString *emailTitle = @"KKBook Feedback";
    // Email Content
    NSString *messageBody = @"KKBook app is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"suthisak.ch@gmail.com"];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:emailTitle];
    [controller setMessageBody:messageBody isHTML:NO];
    [controller setToRecipients:toRecipents];
    if (controller)
        [self presentViewController:controller animated:YES completion:^(){}];
}

- (IBAction)didHelpGuide:(id)sender {
}

#pragma mark - MFMailCompose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^(){}];
}

@end
