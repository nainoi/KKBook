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
#import "DataManager.h"

@implementation KKBookLibraryCell{
    AFHTTPRequestOperation *operation;
}

- (void)awakeFromNib {
    // Initialization code
    _progresView.hidden = YES;
    _resumeBtn.hidden = YES;
    _resumeBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:0.65];
    [self removeNotification];
    [self addNotification];
}

-(void)setBookEntity:(BookEntity *)bookEntity{
    _bookEntity = bookEntity;
    NSString *coverPath = [[FileHelper coversPath] stringByAppendingPathComponent:_bookEntity.coverName];
    UIImage *image = [UIImage imageWithContentsOfFile:coverPath];
    [_imageCover setImage:image];
    if ([_bookEntity.status isEqualToString:DOWNLOADING]) {
        //operation = [[DataManager shareInstance].responceArray valueForKey:[bookEntity.bookID stringValue]];
        _progresView.hidden = NO;
        _resumeBtn.hidden = YES;
        operation = [[DataManager shareInstance] selectResponseOperationWithBookEntity:bookEntity];
        if (operation) {
            __weak UIProgressView *progress = self.progresView;
            [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalByteReading, long long totalByteWrite){
                float prog = (totalByteReading / (totalByteWrite * 1.0f) /** 100.0*/);
                [progress setProgress:prog];
                NSLog(@"%f%% Uploaded", (totalByteReading / (totalByteWrite * 1.0f) * 100));
            }];
        }
        
        
    }else if ([_bookEntity.status isEqualToString:DOWNLOADFAIL]){
        _progresView.hidden = YES;
        _resumeBtn.hidden = NO;
    }else if ([_bookEntity.status isEqualToString:DOWNLOADCOMPLETE]){
        _progresView.hidden = YES;
        _resumeBtn.hidden = YES;
    }
}
-(void)addNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responceDownload:) name:BookDidResponce object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failDownload:) name:BookDidFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownload:) name:BookDidFinish object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidResponce object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidFail object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BookDidFinish object:nil];
}

-(void)responceDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operations = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operations.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = NO;
        _resumeBtn.hidden = YES;
        [operations setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalByteReading, long long totalByteWrite){
            float prog = (totalByteReading / (totalByteWrite * 1.0f) / 100.0);
            [self.progresView setProgress:prog];
            NSLog(@"%f%% Uploaded", (totalByteReading / (totalByteWrite * 1.0f) * 100));
        }];
    }
}

-(void)failDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operations = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operations.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = YES;
        _resumeBtn.hidden = NO;
    }
}

-(void)finishDownload:(NSNotification*)noti
{
    AFHTTPRequestOperation *operations = (AFHTTPRequestOperation*)noti.object;
    BookEntity *b = (BookEntity*)[operations.userInfo objectForKey:KKBOOK_KEY];
    if (b.bookID == _bookEntity.bookID) {
        _progresView.hidden = YES;
        _resumeBtn.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.labelTitle.textColor = [UIColor colorWithRed:0.18f green:0.20f blue:0.23f alpha:1.00f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    
    self.labelIssue.textColor = [UIColor colorWithRed:1.00f green:0.25f blue:0.55f alpha:1.00f];
    self.labelIssue.backgroundColor = [UIColor clearColor];
    
}

- (IBAction)didResume:(id)sender {
    //operation = [[DataManager shareInstance] selectResponseOperationWithBookEntity:_bookEntity];
    if (operation) {
        [operation resume];
        __weak UIProgressView *progress = self.progresView;
        [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalByteReading, long long totalByteWrite){
            float prog = (totalByteReading / (totalByteWrite * 1.0f) /** 100.0*/);
            [progress setProgress:prog];
            NSLog(@"%f%% Uploaded", (totalByteReading / (totalByteWrite * 1.0f) * 100));
        }];
    }

}
@end
