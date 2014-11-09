//
//  KKBookLibraryCell.m
//  KKBooK
//
//  Created by PromptNow on 11/1/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookLibraryCell.h"
#import "FileHelper.h"
#import "AFHTTPRequestOperation.h"

@implementation KKBookLibraryCell

- (void)awakeFromNib {
    // Initialization code
    _progresView.hidden = YES;
    [self removeNotification];
    [self addNotification];
}

-(void)setBookEntity:(BookEntity *)bookEntity{
    _bookEntity = bookEntity;
    NSString *coverPath = [[FileHelper coversPath] stringByAppendingPathComponent:_bookEntity.coverName];
    UIImage *image = [UIImage imageWithContentsOfFile:coverPath];
    [_imageCover setImage:image];
}
-(void)addNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responceDownload:) name:BookDidStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failDownload:) name:BookDidFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownload:) name:BookDidFinish object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidStart object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidFail object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidFinish object:nil];
}

-(void)responceDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operation.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = NO;
        [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalByteReading, long long totalByteWrite){
            float prog = (totalByteReading / (totalByteWrite * 1.0f) * 100);
            [self.progresView setProgress:prog];
            NSLog(@"%f%% Uploaded", (totalByteReading / (totalByteWrite * 1.0f) * 100));
        }];
    }
}

-(void)failDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operation.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = YES;
    }
}

-(void)finishDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operation.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.labelTitle.textColor = [UIColor colorWithRed:0.18f green:0.20f blue:0.23f alpha:1.00f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    
    self.labelIssue.textColor = [UIColor colorWithRed:1.00f green:0.25f blue:0.55f alpha:1.00f];
    self.labelIssue.backgroundColor = [UIColor clearColor];
    
}

@end
